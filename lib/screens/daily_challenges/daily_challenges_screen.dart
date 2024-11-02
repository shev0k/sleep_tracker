// lib/screens/daily_challenges_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/rounded_card_challenge.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/empty_challenge_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/challenge_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/ongoing_challenge_card.dart';
import 'completed_challenges_screen.dart';
import 'package:sleeping_tracker_ui/models/(challenge)/challenge.dart';
import 'package:sleeping_tracker_ui/services/challenge_service.dart'; // Import ChallengeService

class DailyChallengesScreen extends StatefulWidget {
  const DailyChallengesScreen({super.key});

  @override
  DailyChallengesScreenState createState() => DailyChallengesScreenState();
}

class DailyChallengesScreenState extends State<DailyChallengesScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // State Variables
  List<Challenge> dailyChallenges = [];
  List<Challenge> ongoingChallenges = [];
  bool isLoading = true;
  String? errorMessage;

  final ChallengeService _challengeService = ChallengeService();

  @override
  void initState() {
    super.initState();
    fetchChallenges();
  }

  @override
  void dispose() {
    for (var challenge in ongoingChallenges) {
      if (challenge.timer != null) {
        challenge.timer!.cancel();
        challenge.timer = null;
      }
    }
    super.dispose();
  }

  /// Fetches challenges from the backend and initializes the lists.
  Future<void> fetchChallenges() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Fetch all challenges
      List<Challenge> allChallenges = await _challengeService.getAllChallenges();

      // Fetch active (ongoing) challenges
      List<Challenge> activeChallenges = await _challengeService.getActiveChallenges();

      setState(() {
        // Daily challenges are those not accepted and not completed
        dailyChallenges =
            allChallenges.where((c) => !c.isAccepted && !c.isCompleted).toList();

        // Ongoing challenges are those accepted and not completed
        ongoingChallenges =
            activeChallenges.where((c) => c.isAccepted && !c.isCompleted).toList();

        isLoading = false;
      });

      // Start timers for active challenges if needed
      for (var challenge in ongoingChallenges) {
        if (challenge.type == "time" || challenge.type == "action") {
          startChallengeTimer(challenge);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      _showAlert("Failed to load challenges: $e", Icons.error, () {});
    }
  }

  // Management functions

  /// Accepts a daily challenge and moves it to ongoing challenges.
  Future<void> acceptChallenge(Challenge challenge) async {
    try {
      Challenge updatedChallenge = await _challengeService.acceptChallenge(challenge.id);

      setState(() {
        dailyChallenges.removeWhere((c) => c.id == challenge.id);
        ongoingChallenges.insert(0, updatedChallenge);
      });

      // Start timer if it's a time-based challenge
      if (updatedChallenge.type == "time" || updatedChallenge.type == "action") {
        startChallengeTimer(updatedChallenge);
      }

      // Show alert for accepted challenge with Undo option
      _showAlert(
        "Challenge Accepted!",
        Icons.check_circle,
        () async {
          try {
            // Undo: Revert acceptance
            Challenge revertedChallenge = await _challengeService.updateChallenge(
              updatedChallenge.id,
              {
                'isAccepted': false,
                'startTime': null,
              },
            );

            setState(() {
              ongoingChallenges.removeWhere((c) => c.id == revertedChallenge.id);
              dailyChallenges.insert(0, revertedChallenge);
            });

            // Cancel timer if necessary
            if (revertedChallenge.timer != null) {
              revertedChallenge.timer!.cancel();
              revertedChallenge.timer = null;
            }
          } catch (e) {
            _showAlert("Undo failed: $e", Icons.error, () {});
          }
        },
      );
    } catch (e) {
      _showAlert("Failed to accept challenge: $e", Icons.error, () {});
    }
  }

  /// Cancels an ongoing challenge and moves it back to daily challenges.
  Future<void> cancelChallenge(int index) async {
    final Challenge challenge = ongoingChallenges[index];
    try {
      // Cancel challenge in backend
      Challenge updatedChallenge = await _challengeService.updateChallenge(
        challenge.id,
        {
          'isAccepted': false,
          'isCompleted': false,
          'startTime': null,
          'progress': 0.0,
          'isPaused': false,
          'current': challenge.type == 'count' ? 0 : null,
        },
      );

      setState(() {
        ongoingChallenges.removeAt(index);
        dailyChallenges.insert(0, updatedChallenge);
      });

      // Cancel timer if necessary
      if (updatedChallenge.timer != null) {
        updatedChallenge.timer!.cancel();
        updatedChallenge.timer = null;
      }

      // Show alert for canceled challenge with Undo option
      _showAlert(
        "Challenge Canceled",
        Icons.cancel,
        () async {
          try {
            // Undo: Re-accept the challenge
            Challenge reAcceptedChallenge = await _challengeService.acceptChallenge(challenge.id);

            setState(() {
              dailyChallenges.removeWhere((c) => c.id == reAcceptedChallenge.id);
              ongoingChallenges.insert(index, reAcceptedChallenge);
            });

            // Restart timer if it's a time-based challenge
            if (reAcceptedChallenge.type == "time" || reAcceptedChallenge.type == "action") {
              startChallengeTimer(reAcceptedChallenge);
            }
          } catch (e) {
            _showAlert("Undo failed: $e", Icons.error, () {});
          }
        },
      );
    } catch (e) {
      _showAlert("Failed to cancel challenge: $e", Icons.error, () {});
    }
  }

  /// Completes a challenge and handles rewards and achievements.
  Future<void> completeChallengeByChallenge(Challenge challenge) async {
    try {
      await _challengeService.completeChallenge(challenge.id);

      setState(() {
        ongoingChallenges.removeWhere((c) => c.id == challenge.id);
      });

      // Show alert for completed challenge with Undo option
      _showAlert(
        "Challenge Completed!",
        Icons.check_circle,
        () async {
          try {
            // Undo: Revert completion
            Challenge revertedChallenge = await _challengeService.updateChallenge(
              challenge.id,
              {
                'isCompleted': false,
              },
            );

            setState(() {
              ongoingChallenges.insert(0, revertedChallenge);
            });

            // Restart timer if necessary
            if (revertedChallenge.type == "time" || revertedChallenge.type == "action") {
              startChallengeTimer(revertedChallenge);
            }
          } catch (e) {
            _showAlert("Undo failed: $e", Icons.error, () {});
          }
        },
      );

      // Handle achievements and rewards
      if (challenge.achievement != null) {
        _showAchievementAlert(challenge.achievement!, _mapIcon(challenge.icon));
      }

      if (challenge.reward.type == "item") {
        _showItemRewardAlert(challenge.reward, _mapIcon(challenge.icon));
      }
    } catch (e) {
      _showAlert("Failed to complete challenge: $e", Icons.error, () {});
    }
  }

  // Timer management functions

  /// Starts a timer for time-based challenges.
  void startChallengeTimer(Challenge challenge) {
    if (challenge.timer != null) {
      challenge.timer!.cancel();
    }

    challenge.timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      try {
        // Fetch the latest challenge data
        Challenge latestChallenge = await _challengeService.getChallengeById(challenge.id);

        if (latestChallenge.isCompleted) {
          timer.cancel();
          return;
        }

        setState(() {
          int duration = latestChallenge.duration ?? latestChallenge.timeLimit ?? 0;
          int elapsed = DateTime.now()
              .difference(latestChallenge.startTime ?? DateTime.now())
              .inSeconds;

          if (elapsed >= duration) {
            // Time is up; complete the challenge
            timer.cancel();
            completeChallengeByChallenge(latestChallenge);
          } else {
            // Update progress
            latestChallenge.progress = elapsed / duration;
            // Update the challenge in the list
            int index = ongoingChallenges.indexWhere((c) => c.id == latestChallenge.id);
            if (index != -1) {
              ongoingChallenges[index] = latestChallenge;
            }
          }
        });
      } catch (e) {
        timer.cancel();
        _showAlert("Timer error: $e", Icons.error, () {});
      }
    });
  }

  // Count management functions

  /// Increments the count for count-based challenges.
  Future<void> incrementCount(Challenge challenge) async {
    try {
      Challenge updatedChallenge = await _challengeService.updateProgress(
        challenge.id,
        {
          'current': (challenge.current ?? 0) + 1,
        },
      );

      setState(() {
        int index = ongoingChallenges.indexWhere((c) => c.id == updatedChallenge.id);
        if (index != -1) {
          ongoingChallenges[index] = updatedChallenge;
        }
      });

      if (updatedChallenge.current != null &&
          updatedChallenge.target != null &&
          updatedChallenge.current! >= updatedChallenge.target!) {
        _confirmCompletion(context, updatedChallenge);
      }
    } catch (e) {
      _showAlert("Failed to increment count: $e", Icons.error, () {});
    }
  }

  /// Decrements the count for count-based challenges.
  Future<void> decrementCount(Challenge challenge) async {
    if ((challenge.current ?? 0) <= 0) return;

    try {
      Challenge updatedChallenge = await _challengeService.updateProgress(
        challenge.id,
        {
          'current': (challenge.current ?? 0) - 1,
        },
      );

      setState(() {
        int index = ongoingChallenges.indexWhere((c) => c.id == updatedChallenge.id);
        if (index != -1) {
          ongoingChallenges[index] = updatedChallenge;
        }
      });
    } catch (e) {
      _showAlert("Failed to decrement count: $e", Icons.error, () {});
    }
  }

  // Timer management functions

  /// Starts a challenge by setting it as accepted and initiating the timer
  void startChallenge(Challenge challenge) {
    setState(() {
      challenge.isAccepted = true;
      challenge.startTime = DateTime.now();
      challenge.isPaused = false;
    });

    if (challenge.type == "time" || challenge.type == "action") {
      startChallengeTimer(challenge);
    }
  }

  /// Pauses an ongoing challenge and records elapsed time
  void pauseChallenge(Challenge challenge) {
    setState(() {
      challenge.isPaused = true;
      if (challenge.timer != null) {
        challenge.timer!.cancel();
        challenge.timer = null;
      }
      // Calculate elapsed time and adjust startTime
      DateTime startTime = challenge.startTime!;
      int elapsed = DateTime.now().difference(startTime).inSeconds;
      challenge.elapsed = elapsed;
    });
  }

  /// Resumes a paused challenge by adjusting the start time and restarting the timer
  void resumeChallenge(Challenge challenge) {
    setState(() {
      challenge.isPaused = false;
      // Adjust startTime based on elapsed time
      int elapsed = challenge.elapsed ?? 0;
      challenge.startTime = DateTime.now().subtract(Duration(seconds: elapsed));
    });
    startChallengeTimer(challenge);
  }


  // Alert and confirmation Dialogs

  /// Shows a SnackBar alert with an Undo option.
  void _showAlert(String message, IconData icon, VoidCallback onUndo) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
            IconButton(
              icon: const Icon(Icons.undo, color: Colors.white),
              onPressed: () {
                scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                onUndo();
              },
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Prompts the user to confirm challenge completion.
  Future<void> _confirmCompletion(BuildContext context, Challenge challenge) async {
    bool? result = await showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Complete Challenge?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Do you want to complete this challenge?",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancel
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true); // Complete
                        },
                        child: const Text(
                          "Complete",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result == true) {
      await completeChallengeByChallenge(challenge);
    }
  }

  /// Displays an achievement alert dialog.
  void _showAchievementAlert(Achievement achievement, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Achievement Unlocked!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Displays an item reward alert dialog.
  void _showItemRewardAlert(Reward reward, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "New Item Unlocked!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  reward.value.toString(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Formats the remaining time into a human-readable string.
  String _formatTimeLeft(int seconds) {
    if (seconds <= 0) return "Completed";
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return "$hours hr $minutes min left";
    } else {
      return "$minutes min left";
    }
  }

  /// Maps the icon string to an IconData.
  IconData _mapIcon(String? iconName) {
    switch (iconName) {
      case 'screen_lock_portrait':
        return Icons.screen_lock_portrait;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'book':
        return Icons.book;
      case 'directions_walk':
        return Icons.directions_walk;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05;
    double cardWidth = screenWidth * 0.8;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Daily Challenges",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(
                      "Error: $errorMessage",
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Completed Challenges Section
                          RoundedCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 30),
                                const Text(
                                  "Completed Challenges",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                  onPressed: () {
                                    // Navigate to Completed Challenges Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CompletedChallengesScreen()),
                                    );
                                  },
                                  tooltip: 'View Completed Challenges',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30.0),

                          // Daily Challenges Section
                          Text(
                            "Daily",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          dailyChallenges.isEmpty
                              ? EmptyChallengeCard(
                                  width: cardWidth,
                                  message: "No more challenges for today")
                              : ChallengeList(
                                  challenges: dailyChallenges,
                                  cardWidth: cardWidth,
                                  onAccept: acceptChallenge,
                                ),

                          const SizedBox(height: 30.0),

                          // Ongoing Challenges Section
                          Text(
                            "Ongoing",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ongoingChallenges.isEmpty
                              ? EmptyChallengeCard(
                                  width: cardWidth,
                                  message: "No ongoing challenges")
                              : ListView.builder(
                                  itemCount: ongoingChallenges.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final Challenge challenge =
                                        ongoingChallenges[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      child: OngoingChallengeCard(
                                        challenge: challenge,
                                        onComplete: () =>
                                            _confirmCompletion(context, challenge),
                                        onIncrement: () =>
                                            incrementCount(challenge),
                                        onDecrement: () =>
                                            decrementCount(challenge),
                                        onStart: () => startChallenge(challenge),
                                        onPause: () => pauseChallenge(challenge),
                                        onResume: () => resumeChallenge(challenge),
                                        formatTimeLeft: _formatTimeLeft,
                                        getIcon: _mapIcon,
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
