// lib/components/widgets/ongoing_challenge_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sleeping_tracker_ui/models/(challenge)/challenge.dart';
import 'package:sleeping_tracker_ui/models/reward.dart';
import 'package:sleeping_tracker_ui/models/item.dart';

class OngoingChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onComplete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final String Function(int) formatTimeLeft;
  final IconData Function(String?) getIcon;

  const OngoingChallengeCard({
    super.key,
    required this.challenge,
    required this.onComplete,
    required this.onIncrement,
    required this.onDecrement,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.formatTimeLeft,
    required this.getIcon,
  });

  /// Generates the reward text based on the Reward object.
  String _getRewardText(Reward reward) {
    if (reward.type == 'points') {
      return "${reward.value} points";
    } else if (reward.type == 'item' && reward.value is Item) {
      return "${reward.value.name}";
    } else {
      return "Unknown Reward";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extracting relevant fields from the Challenge model
    String title = challenge.title;
    double progress = challenge.progress;
    IconData icon = getIcon(challenge.icon); // Use the passed getIcon function
    String type = challenge.type;
    int? target = challenge.target;
    bool isStarted = challenge.isAccepted;
    DateTime? startTime = challenge.startTime;
    int? duration = challenge.duration;
    Reward? reward = challenge.reward;

    // Calculating time left for 'time' and 'action' type challenges
    int timeLeft = 0;
    if (isStarted && startTime != null && duration != null) {
      timeLeft = duration - DateTime.now().difference(startTime).inSeconds;
      if (timeLeft < 0) timeLeft = 0;
    }

    // Generating reward text
    String rewardText = _getRewardText(reward);

    // Calculate progress fraction
    double progressFraction = 0.0;
    if (type == "time" || type == "action") {
      progressFraction = progress; // Assuming progress is a fraction (0.0 to 1.0)
    } else if (type == "count" && target != null && target > 0) {
      progressFraction = (challenge.current ?? 0) / target;
      if (progressFraction > 1.0) progressFraction = 1.0;
    }

    return Slidable(
      key: ValueKey(challenge.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              // Invoke the onPause or onResume based on challenge state
              if (challenge.isPaused) {
                onResume();
              } else {
                onPause();
              }
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: challenge.isPaused ? Icons.play_arrow : Icons.pause,
            label: challenge.isPaused ? 'Resume' : 'Pause',
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Challenge Row
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white54),
                    onPressed: onComplete,
                    tooltip: 'Complete Challenge',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Conditional Rendering Based on Challenge Status
              if (!isStarted) ...[
                Text(
                  "Not started",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: onStart,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (type == "time" || type == "action") ...[
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 10),

                // Reward Text
                Text(
                  "Reward: $rewardText",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
                const SizedBox(height: 15),

                // Time Left and Complete Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTimeLeft(timeLeft),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: onComplete,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (type == "count") ...[
                // Progress Bar for Count-based Challenges
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 10),

                // Reward Text
                Text(
                  "Reward: $rewardText",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
                const SizedBox(height: 15),

                // Progress Count and Increment/Decrement Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${challenge.current ?? 0} / ${challenge.target ?? 0}",
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                    Row(
                      children: [
                        if ((challenge.current ?? 0) > 0)
                          GestureDetector(
                            onTap: onDecrement,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if ((challenge.current ?? 0) < (challenge.target ?? 0))
                          GestureDetector(
                            onTap: onIncrement,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: onComplete,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
