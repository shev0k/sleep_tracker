// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(settings)/large_card.dart';
import 'profile_settings_screen.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingsContent(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LargeCard(
          label: "Profile Settings",
          icon: Icons.person,
          screen: ProfileSettingsScreen(),
        ),
        SizedBox(height: 5),
        LargeCard(
          label: "Notification Settings",
          icon: Icons.notifications,
          screen: NotificationSettingsScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
            child: _buildSettingsContent(context),
          ),
        ),
      ),
    );
  }
}
