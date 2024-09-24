// lib/components/widgets/ongoing_challenge_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OngoingChallengeCard extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onComplete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final String Function(int) formatTimeLeft;

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
  });

  @override
  Widget build(BuildContext context) {
    String title = challenge["title"];
    double? progress = challenge["progress"];
    IconData icon = challenge["icon"];
    String type = challenge["type"];
    int? target = challenge["target"];
    int? current = challenge["current"];
    bool? isStarted = challenge["isStarted"];
    bool isPaused = challenge["isPaused"] ?? false;
    DateTime? startTime = challenge["startTime"];
    int? duration = challenge["duration"];
    Map<String, dynamic>? reward = challenge["reward"];
    int? timeLimit = challenge["timeLimit"];

    int timeLeft = 0;
    if (isStarted!) {
      if (type == "time" && startTime != null && duration != null) {
        timeLeft = duration - DateTime.now().difference(startTime).inSeconds;
      } else if (type == "action" && startTime != null && timeLimit != null) {
        timeLeft = timeLimit - DateTime.now().difference(startTime).inSeconds;
      }
    }

    String rewardText = reward != null
        ? (reward["type"] == "points"
            ? "${reward["value"]} points"
            : "${reward["value"]}")
        : "";

    return Stack(
      children: [
        Container(
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
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.chevron_right, color: Colors.white54),
                          onPressed: () {
                            Slidable.of(context)?.openStartActionPane();
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
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
                          decoration:
                              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.play_arrow, color: Colors.black, size: 18.0),
                        ),
                      ),
                    ],
                  ),
                ] else if (type == "time" || type == "action") ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Reward: $rewardText",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPaused ? "Paused" : formatTimeLeft(timeLeft),
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: isPaused ? onResume : onPause,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: onComplete,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.check, color: Colors.black, size: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ] else if (type == "count") ...[
                  _buildStageProgressBar(current: current!, target: target!),
                  const SizedBox(height: 10),
                  Text(
                    "Reward: $rewardText",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$current out of $target ${title.contains('glasses') ? 'glasses' : 'steps'}",
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      ),
                      Row(
                        children: [
                          if (current > 0)
                            GestureDetector(
                              onTap: onDecrement,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(Icons.remove, color: Colors.black, size: 18.0),
                              ),
                            ),
                          const SizedBox(width: 10),
                          if (current < target)
                            GestureDetector(
                              onTap: onIncrement,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(Icons.add, color: Colors.black, size: 18.0),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: onComplete,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(Icons.check, color: Colors.black, size: 18.0),
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
      ],
    );
  }

  Widget _buildStageProgressBar({required int current, required int target}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        target,
        (index) => _buildProgressSegment(isActive: index < current),
      ),
    );
  }

  Widget _buildProgressSegment({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
