// lib/screens/completed_challenges_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sleeping_tracker_ui/components/widgets/(daily_challenges)/completed_challenge_card.dart';

class CompletedChallengesScreen extends StatefulWidget {
  const CompletedChallengesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CompletedChallengesScreenState createState() =>
      _CompletedChallengesScreenState();
}

class _CompletedChallengesScreenState extends State<CompletedChallengesScreen> {
  // mock list of challenges
  List<Map<String, dynamic>> challenges = [
    {
      "title": "No screen time 1 hour before bed",
      "icon": Icons.screen_lock_portrait,
      "description": "Avoid using your phone before sleep."
    },
    {
      "title": "Drink no caffeine after 6 PM",
      "icon": Icons.local_cafe,
      "description": "Skip your evening coffee."
    },
    {
      "title": "Sleep for 8 hours",
      "icon": Icons.bedtime,
      "description": "Get a full night's sleep."
    },
    {
      "title": "Exercise for 30 minutes",
      "icon": Icons.fitness_center,
      "description": "Do some physical activity."
    },
    {
      "title": "Meditate for 15 minutes",
      "icon": Icons.self_improvement,
      "description": "Relax and calm your mind."
    },
  ];

  // store the recently deleted challenge for undo functionality
  Map<String, dynamic>? _recentlyDeletedChallenge;
  int? _recentlyDeletedChallengeIndex;

  // GlobalKey
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _deleteChallenge(int index) {
    setState(() {
      _recentlyDeletedChallenge = challenges.removeAt(index);
      _recentlyDeletedChallengeIndex = index;
    });

    // hide any existing SnackBar before showing a new one
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    // show a SnackBar with Undo icon
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900]
                ?.withOpacity(0.95),
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
              ), // delete icon
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  '"${_recentlyDeletedChallenge?["title"]}" has been deleted.',
                  style: const TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ), // deletion message
              const SizedBox(width: 12.0),
              GestureDetector(
                onTap: () {
                  scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                  _undoDelete();
                },
                child: const Icon(
                  Icons.undo,
                  color: Colors.white,
                  size: 24.0,
                  semanticLabel: 'Undo Deletion',
                ), // undo icon
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _undoDelete() {
    if (_recentlyDeletedChallenge != null &&
        _recentlyDeletedChallengeIndex != null) {
      if (mounted) {
        setState(() {
          challenges.insert(
              _recentlyDeletedChallengeIndex!, _recentlyDeletedChallenge!);
          _recentlyDeletedChallenge = null;
          _recentlyDeletedChallengeIndex = null;
        });
      }
    }
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
        body: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: challenges.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: 16.0),
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return Slidable(
              key: ValueKey(challenge["title"]),
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
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 8.0),
                  ),
                ],
              ),
              child: CompletedChallengeCard(
                challenge: challenge,
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
