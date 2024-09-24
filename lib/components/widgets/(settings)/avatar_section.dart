// lib/components/widgets/avatar_section.dart
import 'package:flutter/material.dart';
import '../(home)/rounded_card.dart';

class AvatarSection extends StatelessWidget {
  final String username;

  const AvatarSection({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.black),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            username,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
