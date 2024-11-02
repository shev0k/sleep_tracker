// lib/screens/completed_challenges_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/completed_challenge_card.dart';
import 'package:sleeping_tracker_ui/models/(challenge)/challenge.dart';
import 'package:sleeping_tracker_ui/services/challenge_service.dart';

class CompletedChallengesScreen extends StatefulWidget {
  const CompletedChallengesScreen({super.key});

  @override
  CompletedChallengesScreenState createState() =>
      CompletedChallengesScreenState();
}

class CompletedChallengesScreenState
    extends State<CompletedChallengesScreen> {
  // State Variables
  List<Challenge> challenges = [];
  bool isLoading = true;
  String? errorMessage;

  // Store the recently deleted challenge for undo functionality
  Challenge? _recentlyDeletedChallenge;
  int? _recentlyDeletedChallengeIndex;

  // GlobalKey for ScaffoldMessenger
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Instance of ChallengeService
  final ChallengeService _challengeService = ChallengeService();

  @override
  void initState() {
    super.initState();
    fetchCompletedChallenges();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Fetches completed challenges from the backend and initializes the list.
  Future<void> fetchCompletedChallenges() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Fetch completed challenges from the backend
      List<Challenge> fetchedChallenges =
          await _challengeService.getCompletedChallenges();

      setState(() {
        challenges = fetchedChallenges;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      _showAlert("Failed to load completed challenges: $e", Icons.error, () {});
    }
  }

  /// Deletes a challenge at the specified index and shows a SnackBar with Undo option
  Future<void> _deleteChallenge(int index) async {
    final Challenge challengeToDelete = challenges[index];
    setState(() {
      _recentlyDeletedChallenge = challenges.removeAt(index);
      _recentlyDeletedChallengeIndex = index;
    });

    try {
      // Delete the challenge from the backend
      await _challengeService.deleteChallenge(challengeToDelete.id);

      // Show a SnackBar with Undo option
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          content: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 24.0,
                ), // Delete icon
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    '"${challengeToDelete.title}" has been deleted.',
                    style: const TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ), // Deletion message
                const SizedBox(width: 12.0),
                GestureDetector(
                  onTap: () async {
                    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                    await _undoDelete();
                  },
                  child: const Icon(
                    Icons.undo,
                    color: Colors.white,
                    size: 24.0,
                    semanticLabel: 'Undo Deletion',
                  ), // Undo icon
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // If deletion fails, re-insert the challenge back into the list
      setState(() {
        if (_recentlyDeletedChallengeIndex != null &&
            _recentlyDeletedChallenge != null) {
          challenges.insert(
              _recentlyDeletedChallengeIndex!, _recentlyDeletedChallenge!);
          _recentlyDeletedChallenge = null;
          _recentlyDeletedChallengeIndex = null;
        }
      });
      _showAlert("Failed to delete challenge: $e", Icons.error, () {});
    }
  }

  /// Undoes the last deletion by re-creating the challenge in the backend
  Future<void> _undoDelete() async {
    if (_recentlyDeletedChallenge != null &&
        _recentlyDeletedChallengeIndex != null) {
      try {
        // Re-create the challenge in the backend
        Challenge restoredChallenge =
            await _challengeService.createChallenge(_recentlyDeletedChallenge!);

        setState(() {
          challenges.insert(
              _recentlyDeletedChallengeIndex!, restoredChallenge);
          _recentlyDeletedChallenge = null;
          _recentlyDeletedChallengeIndex = null;
        });
      } catch (e) {
        _showAlert("Undo failed: $e", Icons.error, () {});
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Completed Challenges",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
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
                : challenges.isEmpty
                    ? Center(
                        child: Text(
                          "No completed challenges yet.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: challenges.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16.0),
                        itemBuilder: (context, index) {
                          final challenge = challenges[index];
                          return Slidable(
                            key: ValueKey(challenge.id), // Use a unique identifier
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.35,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    _deleteChallenge(index);
                                  },
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  borderRadius: BorderRadius.circular(16),
                                  padding:
                                      const EdgeInsets.only(left: 16.0, right: 8.0),
                                ),
                              ],
                            ),
                            child: CompletedChallengeCard(
                              challenge: challenge, // Pass the Challenge object
                              onChevronTap: () {
                                Slidable.of(context)?.openStartActionPane();
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
