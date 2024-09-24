// lib/components/widgets/completed_challenge_card.dart

import 'package:flutter/material.dart';

class CompletedChallengeCard extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onChevronTap;

  const CompletedChallengeCard({
    super.key,
    required this.challenge,
    required this.onChevronTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Icon(
            challenge["icon"],
            color: Colors.white,
            size: 30.0,
          ),
          title: Text(
            challenge["title"],
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          subtitle: Text(
            challenge["description"],
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          trailing: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white54),
              onPressed: onChevronTap,
            ),
          ),
        ),
      ),
    );
  }
}
