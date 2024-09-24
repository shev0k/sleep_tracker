// lib/screens/daily_challenges_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/rounded_card_challenge.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/empty_challenge_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/challenge_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/ongoing_challenge_card.dart';
import 'completed_challenges_screen.dart';

class DailyChallengesScreen extends StatefulWidget {
  const DailyChallengesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DailyChallengesScreenState createState() => _DailyChallengesScreenState();
}

class _DailyChallengesScreenState extends State<DailyChallengesScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  List<Map<String, dynamic>> dailyChallenges = [
    {
      "title": "No screen time 1 hour before bed",
      "reward": {"type": "points", "value": 10},
      "icon": Icons.screen_lock_portrait,
      "type": "time",
      "duration": 1 * 60 * 60,
      "achievement": {
        "title": "Night Owl",
        "description": "Avoided screen time before bed",
      },
    },
    {
      "title": "Meditate for 10 minutes",
      "reward": {"type": "item", "value": "Meditation Badge"},
      "icon": Icons.self_improvement,
      "type": "action",
      "timeLimit": 10 * 60,
      "isStarted": false,
    },
    // add more shitty challenges
    {
      "title": "Read a book for 30 minutes",
      "reward": {"type": "points", "value": 15},
      "icon": Icons.book,
      "type": "time",
      "duration": 30 * 60, 
      "achievement": {
        "title": "Bookworm",
        "description": "Read for 30 minutes",
      },
    },
    {
      "title": "Walk 5000 steps",
      "reward": {"type": "points", "value": 20},
      "icon": Icons.directions_walk,
      "type": "count",
      "target": 5000,
      "current": 0,
      "achievement": {
        "title": "Crawl Walker",
        "description": "Walked 5000 steps",
      },
    },
  ];

  List<Map<String, dynamic>> ongoingChallenges = [
    {
      "title": "Sleep for 8 hours",
      "progress": null, 
      "icon": Icons.nights_stay,
      "type": "time",
      "reward": {"type": "points", "value": 20},
      "duration": 8 * 60 * 60, 
      "isStarted": true,
      "startTime": DateTime.now().subtract(const Duration(hours: 4)), 
      "timer": null,
    },
    {
      "title": "Drink 8 glasses of water",
      "progress": null,
      "icon": Icons.local_drink,
      "type": "count",
      "target": 8,
      "current": 3, 
      "reward": {"type": "item", "value": "Water Bottle"},
      "isStarted": true,
      "achievement": {
        "title": "Hydration Hero",
        "description": "Drank 8 glasses of water",
      },
    },
    {
      "title": "Exercise for 30 minutes",
      "progress": null,
      "icon": Icons.fitness_center,
      "type": "time",
      "reward": {"type": "item", "value": "Fitness Badge"},
      "duration": 30 * 60, 
      "isStarted": false,
    },
  ];

  @override
  void initState() {
    super.initState();

    // initial progress for ongoing challenges
    for (var challenge in ongoingChallenges) {
      if (challenge["isStarted"] == true) {
        if (challenge["type"] == "time" || challenge["type"] == "action") {
          DateTime startTime = challenge["startTime"];
          int duration = challenge["duration"] ?? challenge["timeLimit"];
          int elapsed = DateTime.now().difference(startTime).inSeconds;

          // elapsed time is not negative
          if (elapsed < 0) {
            elapsed = 0;
            challenge["startTime"] = DateTime.now();
          }

          // elapsed time does not exceed duration
          if (elapsed >= duration) {
            elapsed = duration;
            challenge["progress"] = 1.0;
            completeChallengeByChallenge(challenge);
          } else {
            challenge["progress"] = elapsed / duration;
          }
        }
      }
    }

    // start timers for already started challenges
    for (var challenge in ongoingChallenges) {
      if (challenge["isStarted"] == true &&
          (challenge["type"] == "time" || challenge["type"] == "action")) {
        startChallengeTimer(challenge);
      }
    }
  }

  @override
  void dispose() {
    for (var challenge in ongoingChallenges) {
      if (challenge["timer"] != null) {
        challenge["timer"].cancel();
        challenge["timer"] = null;
      }
    }
    super.dispose();
  }

  // management functions
  void acceptChallenge(int index) {
    final challenge = dailyChallenges[index];
    setState(() {
      dailyChallenges.removeAt(index);
      challenge["progress"] = null;
      challenge["isStarted"] = false;
      challenge["startTime"] = null; 
      ongoingChallenges.insert(0, challenge);
    });

    // show alert for accepted challenge
    _showAlert(
      "Challenge Accepted!",
      Icons.check_circle,
      () {
        // undo action
        if (mounted) {
          setState(() {
            if (ongoingChallenges.contains(challenge)) {
              ongoingChallenges.remove(challenge);
              dailyChallenges.insert(index, challenge);
            }
          });
        }
      },
    );
  }

  void cancelChallenge(int index) {
    final challenge = ongoingChallenges[index];
    if (challenge["timer"] != null) {
      challenge["timer"].cancel();
      challenge["timer"] = null; // leave to NULL or else go boom boom
    }

    // index where the challenge will be put in dailyChallenges
    int dailyInsertIndex = 0;

    setState(() {
      ongoingChallenges.removeAt(index);
      dailyChallenges.insert(dailyInsertIndex, challenge); // insert back to daily challenges
    });

    // alert for canceled challenge
    _showAlert(
      "Challenge Canceled",
      Icons.cancel,
      () {
        // Undo action
        if (mounted) {
          setState(() {
            if (!ongoingChallenges.contains(challenge)) {
              // remove the challenge from dailyChallenges
              dailyChallenges.remove(challenge);
              // put the challenge back into ongoingChallenges at prev index
              ongoingChallenges.insert(index, challenge);

              // if challenge was started and not paused, restart timer
              if (challenge["isStarted"] == true &&
                  !(challenge["isPaused"] ?? false) &&
                  (challenge["type"] == "time" || challenge["type"] == "action")) {
                startChallengeTimer(challenge);
              }
            }
          });
        }
      },
    );
  }

  void completeChallengeByChallenge(Map<String, dynamic> challenge) {
    if (challenge["timer"] != null) {
      challenge["timer"].cancel();
      challenge["timer"] = null; // another leave NULL or boom boom
    }
    setState(() {
      ongoingChallenges.remove(challenge);
      _showAlert(
        "Challenge Completed!",
        Icons.check_circle,
        () {
          if (mounted) {
            setState(() {
              if (!ongoingChallenges.contains(challenge)) {
                ongoingChallenges.insert(0, challenge);
                if (challenge["isStarted"] == true &&
                    !(challenge["isPaused"] ?? false) &&
                    (challenge["type"] == "time" || challenge["type"] == "action")) {
                  startChallengeTimer(challenge);
                }
              }
            });
          }
        },
      );
    });

    // check challenge has achievement
    if (challenge.containsKey("achievement")) {
      // show achievement alert
      _showAchievementAlert(challenge["achievement"], challenge["icon"]);
    }

    // check challenge reward is item
    if (challenge["reward"]["type"] == "item") {
      // show item reward alert
      _showItemRewardAlert(challenge["reward"], challenge["icon"]);
    }
  }

  // timer management functions
  void startChallenge(Map<String, dynamic> challenge) {
    setState(() {
      challenge["isStarted"] = true;
      challenge["startTime"] = DateTime.now();
      challenge["isPaused"] = false;
    });

    if (challenge["type"] == "time" || challenge["type"] == "action") {
      startChallengeTimer(challenge);
    }
  }

  void pauseChallenge(Map<String, dynamic> challenge) {
    setState(() {
      challenge["isPaused"] = true;
      if (challenge["timer"] != null) {
        challenge["timer"].cancel();
        challenge["timer"] = null;
      }
      // calculate elapsed time and adjust startTime
      DateTime startTime = challenge["startTime"];
      int elapsed = DateTime.now().difference(startTime).inSeconds;
      challenge["elapsed"] = elapsed;
    });
  }

  void resumeChallenge(Map<String, dynamic> challenge) {
    setState(() {
      challenge["isPaused"] = false;
      // adjust startTime
      int elapsed = challenge["elapsed"] ?? 0;
      challenge["startTime"] = DateTime.now().subtract(Duration(seconds: elapsed));
    });
    startChallengeTimer(challenge);
  }

  void startChallengeTimer(Map<String, dynamic> challenge) {
    if (challenge["timer"] != null) {
      challenge["timer"].cancel();
    }

    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (challenge["isStarted"] == true &&
            !(challenge["isPaused"] ?? false)) {
          setState(() {
            DateTime startTime = challenge["startTime"];
            int duration = challenge["duration"] ?? challenge["timeLimit"];
            int elapsed = DateTime.now().difference(startTime).inSeconds;
            if (elapsed >= duration) {
              // challenge completed
              timer.cancel();
              challenge["timer"] = null;
              completeChallengeByChallenge(challenge);
            } else {
              // update progress
              challenge["progress"] = elapsed / duration;
            }
          });
        } else {
          timer.cancel();
          challenge["timer"] = null;
        }
      } else {
        timer.cancel();
        challenge["timer"] = null;
      }
    });

    challenge["timer"] = timer;
  }

  // count management functions
  void incrementCount(Map<String, dynamic> challenge) {
    setState(() {
      if (challenge["current"]! < challenge["target"]!) {
        challenge["current"]++;
        if (challenge["current"] == challenge["target"]) {
          _confirmCompletion(context, challenge);
        }
      }
    });
  }

  void decrementCount(Map<String, dynamic> challenge) {
    setState(() {
      if (challenge["current"]! > 0) {
        challenge["current"]--;
      }
    });
  }

  // alert and confirmation Dialogs
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

  Future<void> _confirmCompletion(BuildContext context, Map<String, dynamic> challenge) async {
    bool? result = await showDialog(
      context: context,
      barrierDismissible: false,
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
              mainAxisSize: MainAxisSize.min, 
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
                          Navigator.of(context).pop(false); 
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
                          Navigator.of(context).pop(true);
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
      completeChallengeByChallenge(challenge);
    }
  }

  void _showAchievementAlert(Map<String, dynamic> achievement, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false, 
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
              mainAxisSize: MainAxisSize.min,
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
                  achievement["title"],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                Text(
                  achievement["description"],
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
                    Navigator.of(context).pop(); 
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

  void _showItemRewardAlert(Map<String, dynamic> reward, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false, 
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
              mainAxisSize: MainAxisSize.min,
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
                  reward["value"],
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
                    Navigator.of(context).pop(); 
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
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completed Challenges Section
                RoundedCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 30),
                      const Text(
                        "Completed Challenges",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          // Navigate to Completed Challenges Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CompletedChallengesScreen()),
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
                        width: cardWidth, message: "No more challenges for today")
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
                        width: cardWidth, message: "No ongoing challenges")
                    : ListView.builder(
                        itemCount: ongoingChallenges.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var challenge = ongoingChallenges[index];
                          return Container(
                            margin:
                                const EdgeInsets.only(bottom: 16.0),
                            child: Slidable(
                              key: ValueKey(challenge["title"]),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.35, 
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      cancelChallenge(index);
                                    },
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel,
                                    label: 'Cancel',
                                    borderRadius: BorderRadius.circular(16),
                                    padding:
                                        EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              child: OngoingChallengeCard(
                                challenge: challenge,
                                onComplete: () => _confirmCompletion(context, challenge),
                                onIncrement: () => incrementCount(challenge),
                                onDecrement: () => decrementCount(challenge),
                                onStart: () => startChallenge(challenge),
                                onPause: () => pauseChallenge(challenge),
                                onResume: () => resumeChallenge(challenge),
                                formatTimeLeft: _formatTimeLeft,
                              ),
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
