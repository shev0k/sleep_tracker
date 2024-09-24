// lib/components/widgets/bottom_button.dart

import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget screen;

  const BottomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.screen,
  });

  void _navigateToScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70, // fixed width for all navigation buttons to ensure alignment
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: IconButton(
              icon: Icon(icon, size: 30, color: Colors.white),
              onPressed: () => _navigateToScreen(context),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}