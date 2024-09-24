import 'package:flutter/material.dart';
import 'rounded_card_progress.dart';

class AchievementCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool unlocked;

  const AchievementCard({
    super.key,
    required this.icon,
    required this.name,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
        leading: Icon(icon, color: unlocked ? Colors.white : Colors.grey),
        title: Text(
          name,
          style: TextStyle(color: unlocked ? Colors.white : Colors.grey),
        ),
        trailing: Icon(unlocked ? Icons.check_circle : Icons.lock, color: Colors.white),
      ),
    );
  }
}
