// lib/screens/achievements_screen.dart

import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/achievement_card.dart';
import 'package:sleeping_tracker_ui/models/progress.dart';

class AchievementsScreen extends StatelessWidget {
  final Progress progress;

  const AchievementsScreen({super.key, required this.progress});

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'bedtime':
        return Icons.bedtime;
      case 'alarm':
        return Icons.alarm;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'nature':
        return Icons.nature;
      case 'spa':
        return Icons.spa;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'alarm_off':
        return Icons.alarm_off;
      case 'wb_sunny':
        return Icons.wb_sunny;
      // Add more mappings as needed
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define all possible achievements (you should maintain this list based on your backend)
    final List<Map<String, dynamic>> allAchievements = [
      {"icon": 'bedtime', "name": "Sleep 7 hours"},
      {"icon": 'alarm', "name": "Wake up early"},
      {"icon": 'nature', "name": "Sleep 8 hours"},
      {"icon": 'nights_stay', "name": "No screens before bed"},
      {"icon": 'alarm_off', "name": "Wake up at 5 AM"},
      {"icon": 'wb_sunny', "name": "Sleep before 10 PM for 7 days"},
      // Add more achievements as needed
    ];

    // Compute locked achievements
    List<Map<String, dynamic>> lockedAchievements = allAchievements.where((achievement) {
      return !progress.achievements.any((a) => a.title == achievement['name']);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Achievements",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unlocked Achievements
              Text(
                "Unlocked Achievements",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              progress.achievements.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: progress.achievements
                          .map((achievement) => AchievementCard(
                                icon: _getIconData(achievement.icon),
                                name: achievement.title,
                                unlocked: true,
                              ))
                          .toList(),
                    )
                  : const Text(
                      "No achievements unlocked yet.",
                      style: TextStyle(color: Colors.white70),
                    ),
              const SizedBox(height: 20),
              // Locked Achievements
              Text(
                "Locked Achievements",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              lockedAchievements.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: lockedAchievements
                          .map((achievement) => AchievementCard(
                                icon: _getIconData(achievement['icon']),
                                name: achievement['name'],
                                unlocked: false,
                              ))
                          .toList(),
                    )
                  : const Text(
                      "All achievements unlocked!",
                      style: TextStyle(color: Colors.white70),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
