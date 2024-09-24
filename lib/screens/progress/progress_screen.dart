import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/rounded_card_progress.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/achievement_icon.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/item_card.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/progress_segment.dart';
import 'achievements_screen.dart';
import 'garden_stages_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final List<String> gardenStages = [
    "Wasteland",
    "Dry Ground",
    "Sprouting Garden",
    "Lush Garden",
    "Blossoming Garden",
  ];

  final List<Map<String, dynamic>> obtainedItems = [
    {"icon": Icons.spa, "name": "New Plant"},
    {"icon": Icons.grass, "name": "Watering Can"},
    {"icon": Icons.eco, "name": "Fertilizer"},
    {"icon": Icons.local_florist, "name": "Garden Shovel"},
    {"icon": Icons.water, "name": "Irrigation System"},
  ];

  final List<Map<String, dynamic>> lockedItems = [
    {"icon": Icons.lock, "name": "Mystery Item 1"},
    {"icon": Icons.lock, "name": "Mystery Item 2"},
  ];

  final ScrollController _scrollController = ScrollController();
  bool isAtStart = true;
  bool isAtEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      isAtStart = _scrollController.position.pixels == 0;
      isAtEnd = _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return RoundedCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AchievementIcon(icon: Icons.bedtime, description: "Sleep 7 hours"),
              AchievementIcon(icon: Icons.alarm, description: "Wake up before 7 AM"),
              AchievementIcon(icon: Icons.nights_stay, description: "No screens..."),
              AchievementIcon(icon: Icons.nature, description: "Sleep 8 hours"),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementsScreen()),
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

  Widget _buildObtainedItemsSection() {
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
                  ...obtainedItems
                      .map((item) => ItemCard(
                            icon: item["icon"],
                            name: item["name"],
                            obtained: true,
                            width: 120,
                          ))
                      ,
                  ...lockedItems
                      .map((item) => ItemCard(
                            icon: item["icon"],
                            name: item["name"],
                            obtained: false,
                            width: 120,
                          ))
                      ,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Achievements",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildAchievementsSection(context),
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
              _buildObtainedItemsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
