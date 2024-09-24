// lib/screens/profile_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:sleeping_tracker_ui/components/widgets/(settings)/rounded_card_settings.dart';
import 'package:sleeping_tracker_ui/components/widgets/(settings)/avatar_section.dart';
import 'package:sleeping_tracker_ui/components/widgets/(settings)/gender_option.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _username = "JohnDoe";
  String _password = "******";
  bool _hasChanges = false;
  String _selectedGender = "Male";
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _updateUsername(String value) {
    setState(() {
      _username = value;
      _hasChanges = true;
    });
  }

  void _updatePassword(String value) {
    setState(() {
      _password = value;
      _hasChanges = true;
    });
  }

  void _updateGender(String gender) {
    setState(() {
      _selectedGender = gender;
      _hasChanges = true;
    });
  }

  void _saveChanges() {
    // implement save functionality here
    setState(() {
      _hasChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes Saved')),
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Username", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          focusNode: _focusNode,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: _username,
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
          onChanged: _updateUsername,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.white),
          obscureText: true,
          decoration: InputDecoration(
            hintText: _password,
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
          onChanged: _updatePassword,
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            GenderOption(
              gender: 'Male',
              selectedGender: _selectedGender,
              onSelected: _updateGender,
            ),
            GenderOption(
              gender: 'Female',
              selectedGender: _selectedGender,
              onSelected: _updateGender,
            ),
            GenderOption(
              gender: 'Other',
              selectedGender: _selectedGender,
              onSelected: _updateGender,
            ),
          ],
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
          "Profile Settings",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AvatarSection(username: _username),
              const SizedBox(height: 20),
              RoundedCard(child: _buildUsernameField()),
              const SizedBox(height: 20),
              RoundedCard(child: _buildPasswordField()),
              const SizedBox(height: 20),
              RoundedCard(child: _buildGenderSection()),
              const SizedBox(height: 20),
              if (_hasChanges)
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Save Changes"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
