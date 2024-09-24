import 'package:flutter/material.dart';

class ProgressSegment extends StatelessWidget {
  final bool isActive;

  const ProgressSegment({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
