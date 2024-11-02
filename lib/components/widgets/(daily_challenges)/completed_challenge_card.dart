// lib/components/widgets/completed_challenge_card.dart

import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/models/(challenge)/challenge.dart';

class CompletedChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onChevronTap;

  const CompletedChallengeCard({
    Key? key,
    required this.challenge,
    required this.onChevronTap,
  }) : super(key: key);

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
    return reward.type == 'points' ? "${reward.value} points" : "${reward.value}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(
          _mapIcon(challenge.icon),
          color: Colors.white,
          size: 30.0,
          semanticLabel: '${challenge.title} Icon',
        ),
        title: Text(
          challenge.title,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.description,
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 4.0),
            Text(
              "Reward: ${_getRewardText(challenge.reward)}",
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            if (challenge.achievement != null) ...[
              const SizedBox(height: 4.0),
              Text(
                "Achievement: ${challenge.achievement!.title}",
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white54),
          onPressed: onChevronTap,
          tooltip: 'View Details',
        ),
      ),
    );
  }
}
