// lib/components/widgets/challenge_card.dart

import 'package:flutter/material.dart';

class ChallengeList extends StatelessWidget {
  final List<Map<String, dynamic>> challenges;
  final double cardWidth;
  final Function(int) onAccept;

  const ChallengeList({
    super.key,
    required this.challenges,
    required this.cardWidth,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          var reward = challenges[index]["reward"];
          String rewardText = reward["type"] == "points"
              ? "${reward["value"]} points"
              : "${reward["value"]}";

          return Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    challenges[index]["icon"],
                    color: Colors.white,
                    size: 28.0,
                    semanticLabel: '${challenges[index]["title"]} Icon',
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    challenges[index]["title"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Reward: $rewardText",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => onAccept(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
