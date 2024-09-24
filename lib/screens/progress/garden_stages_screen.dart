import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(progress)/rounded_card_progress.dart';

class GardenStagesScreen extends StatefulWidget {
  const GardenStagesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GardenStagesScreenState createState() => _GardenStagesScreenState();
}

class _GardenStagesScreenState extends State<GardenStagesScreen> {
  final List<String> stages = [
    "Wasteland",
    "Dry Ground",
    "Sprouting Garden",
    "Lush Garden",
    "Blossoming Garden",
  ];

  int _currentStageIndex = 2; // index of the currently selected garden stage
  final int _unlockedStages = 2; // for mocking, stages 0 to 2 are unlocked

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    super.dispose();
  }

  Widget _buildStageCard(String stage, bool isUnlocked, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          setState(() {
            _currentStageIndex = stages.indexOf(stage);
          });
          _showAlert("Your garden’s look has changed!", Icons.check_circle);
        }
      },
      child: RoundedCard(
        padding: const EdgeInsets.all(12.0),
        border: isSelected
            ? Border.all(color: Colors.white, width: 2)
            : null,
        child: ListTile(
          leading: Icon(
            Icons.local_florist,
            color: isUnlocked ? Colors.white : Colors.grey,
          ),
          title: Text(
            stage,
            style: TextStyle(
              color: isUnlocked ? Colors.white : Colors.grey,
            ),
          ),
          trailing: Icon(
            isUnlocked ? Icons.check_circle : Icons.lock,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showAlert(String message, IconData icon) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Garden Stages",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: stages.length,
            itemBuilder: (context, index) {
              String stage = stages[index];
              bool isUnlocked = index <= _unlockedStages;
              bool isSelected = index == _currentStageIndex;

              return _buildStageCard(stage, isUnlocked, isSelected);
            },
          ),
        ),
      ),
    );
  }
}
