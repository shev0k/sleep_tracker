// lib/screens/progress_screen.dart

import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/achievement_icon.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/item_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/progress_segment.dart';
import 'package:sleeping_tracker_ui/services/progress_service.dart';
import 'package:sleeping_tracker_ui/models/progress.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/rounded_card_progress.dart';
import 'achievements_screen.dart';
import 'garden_stages_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  final ProgressService _progressService = ProgressService();
  late Future<Progress> _progressFuture;

  final List<Map<String, dynamic>> allAchievements = [
    {"icon": 'bedtime', "name": "Sleep 7 hours"},
    {"icon": 'alarm', "name": "Wake up early"},
    {"icon": 'nature', "name": "Sleep 8 hours"},
    {"icon": 'nights_stay', "name": "No screens before bed"},
    {"icon": 'alarm_off', "name": "Wake up at 5 AM"},
    {"icon": 'wb_sunny', "name": "Sleep before 10 PM for 7 days"},
    // Add more achievements as needed
  ];

  final List<Map<String, dynamic>> allItems = [
    {"icon": 'spa', "name": "New Plant"},
    {"icon": 'grass', "name": "Watering Can"},
    {"icon": 'eco', "name": "Fertilizer"},
    {"icon": 'local_florist', "name": "Garden Shovel"},
    {"icon": 'water', "name": "Irrigation System"},
    {"icon": 'lock', "name": "Mystery Item 1"},
    {"icon": 'lock', "name": "Mystery Item 2"},
    // Add more items as needed
  ];

  final ScrollController _scrollController = ScrollController();

  bool isAtStart = true;
  bool isAtEnd = false;

  @override
  void initState() {
    super.initState();
    _progressFuture = _progressService.getProgress();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      isAtStart = _scrollController.position.pixels == 0;
      isAtEnd =
          _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAchievementsSection(BuildContext context, Progress progress) {
    return RoundedCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          // Display unlocked achievements
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: progress.achievements
                .map((achievement) => AchievementIcon(
                      icon: _getIconData(achievement.icon),
                      description: achievement.title,
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AchievementsScreen(progress: progress)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text("View All"),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenGrowthSection(BuildContext context) {
    return RoundedCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.spa, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                "Sprouting Garden",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stages Progress Bar
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProgressSegment(isActive: true),
              ProgressSegment(isActive: true),
              ProgressSegment(isActive: true),
              ProgressSegment(isActive: false),
              ProgressSegment(isActive: false),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Your garden evolves with your sleep quality. Keep improving your sleep score!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GardenStagesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("View All"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObtainedItemsSection(Progress progress) {
    // Compute locked items
    List<Map<String, dynamic>> lockedItems = allItems.where((item) {
      return !progress.items.any((i) => i.name == item['name']);
    }).toList();

    return RoundedCard(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: _scrollLeft,
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: [
                  // Display obtained items
                  ...progress.items
                      .map((item) => ItemCard(
                            icon: _getIconData(item.icon),
                            name: item.name,
                            obtained: true,
                            width: 120,
                          )),
                  // Display locked items
                  ...lockedItems
                      .map((item) => ItemCard(
                            icon: Icons.lock, // Use a lock icon for locked items
                            name: item['name'],
                            obtained: false,
                            width: 120,
                          )),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.white,
            onPressed: _scrollRight,
          ),
        ],
      ),
    );
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels == 0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.animateTo(
          _scrollController.offset - 130,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.animateTo(
          _scrollController.offset + 130,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  IconData _getIconData(String? iconName) {
    // Map string icon names to IconData
    // This requires that your backend sends icon names that match Flutter's Icons
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Progress",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<Progress>(
        future: _progressFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // No data state
            return const Center(child: Text('No progress data found.'));
          } else {
            // Data loaded
            Progress progress = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Achievements Section
                    Text(
                      "Achievements",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAchievementsSection(context, progress),
                    const SizedBox(height: 40),
                    // Garden Stages Section
                    Text(
                      "Garden Stages",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildGardenGrowthSection(context),
                    const SizedBox(height: 40),
                    // Obtained Items Section
                    Text(
                      "Obtained Items",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildObtainedItemsSection(progress),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
