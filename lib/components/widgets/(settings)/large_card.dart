// lib/components/widgets/large_card.dart
import 'package:flutter/material.dart';

class LargeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget screen;

  const LargeCard({
    super.key,
    required this.label,
    required this.icon,
    required this.screen,
  });

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 70),
            ),
            const SizedBox(height: 20),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
