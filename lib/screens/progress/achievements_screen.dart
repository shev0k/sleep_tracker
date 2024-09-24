import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/achievement_card.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> achievements = [
    {"icon": Icons.bedtime, "name": "Sleep 7 hours"},
    {"icon": Icons.alarm, "name": "Wake up early"},
    {"icon": Icons.nature, "name": "Sleep 8 hours"},
    {"icon": Icons.nights_stay, "name": "No screens before bed"},
  ];

  final List<Map<String, dynamic>> lockedAchievements = [
    {"icon": Icons.alarm_off, "name": "Wake up at 5 AM"},
    {"icon": Icons.wb_sunny, "name": "Sleep before 10 PM for 7 days"},
  ];

  AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text(
                "Unlocked Achievements",
                 style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...achievements.map((achievement) => AchievementCard(
                    icon: achievement["icon"],
                    name: achievement["name"],
                    unlocked: true,
                  )),
              const SizedBox(height: 20),
              Text(
                "Locked Achievements",
                 style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...lockedAchievements.map((achievement) => AchievementCard(
                    icon: achievement["icon"],
                    name: achievement["name"],
                    unlocked: false,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
