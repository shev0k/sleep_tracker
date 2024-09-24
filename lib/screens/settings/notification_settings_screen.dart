// lib/screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(settings)/rounded_card_settings.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _bedtimeReminders = true;
  bool _challengeUpdates = false;

  void _toggleBedtimeReminders(bool value) {
    setState(() {
      _bedtimeReminders = value;
    });
  }

  void _toggleChallengeUpdates(bool value) {
    setState(() {
      _challengeUpdates = value;
    });
  }

  Widget _buildBedtimeRemindersSwitch() {
    return SwitchListTile(
      title: const Text("Bedtime Reminders", style: TextStyle(color: Colors.white)),
      value: _bedtimeReminders,
      activeTrackColor: Colors.black,
      onChanged: _toggleBedtimeReminders,
    );
  }

  Widget _buildChallengeUpdatesSwitch() {
    return SwitchListTile(
      title: const Text("Challenge Updates", style: TextStyle(color: Colors.white)),
      value: _challengeUpdates,
      activeTrackColor: Colors.black,
      onChanged: _toggleChallengeUpdates,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Notification Settings",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RoundedCard(child: _buildBedtimeRemindersSwitch()),
            const SizedBox(height: 20),
            RoundedCard(child: _buildChallengeUpdatesSwitch()),
          ],
        ),
      ),
    );
  }
}
