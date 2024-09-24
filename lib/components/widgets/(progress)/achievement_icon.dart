import 'package:flutter/material.dart';

class AchievementIcon extends StatelessWidget {
  final IconData icon;
  final String description;

  const AchievementIcon({
    super.key,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    String displayText = description.length > 10 ? '${description.substring(0, 7)}...' : description;

    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 50),
        const SizedBox(height: 7),
        Text(
          displayText,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
