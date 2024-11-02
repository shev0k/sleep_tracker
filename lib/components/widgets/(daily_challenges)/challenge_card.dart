// lib/components/widgets/challenge_list.dart

import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/models/(challenge)/challenge.dart';
import 'package:sleeping_tracker_ui/models/reward.dart';
import 'package:sleeping_tracker_ui/models/item.dart';

class ChallengeList extends StatelessWidget {
  final List<Challenge> challenges;
  final double cardWidth;
  final Function(Challenge) onAccept;

  const ChallengeList({
    super.key,
    required this.challenges,
    required this.cardWidth,
    required this.onAccept,
  });

  /// Maps the icon string from the backend to IconData.
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
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          Challenge challenge = challenges[index];
          String rewardText = _getRewardText(challenge.reward);

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
                    _mapIcon(challenge.icon),
                    color: Colors.white,
                    size: 28.0,
                    semanticLabel: '${challenge.title} Icon',
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    challenge.title,
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
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => onAccept(challenge),
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
