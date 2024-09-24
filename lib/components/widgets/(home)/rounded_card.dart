// lib/components/widgets/rounded_card.dart

import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;

  const RoundedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
