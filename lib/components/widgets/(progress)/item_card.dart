import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool obtained;
  final double width;

  const ItemCard({
    super.key,
    required this.icon,
    required this.name,
    required this.obtained,
    this.width = 82.0,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = name.length > 10 ? '${name.substring(0, 10)}...' : name;

    return Container(
      width: 82,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: obtained ? Colors.white : Colors.grey, size: 50),
          const SizedBox(height: 5),
          Text(
            displayName,
            style: TextStyle(color: obtained ? Colors.white : Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
