import 'package:flutter/material.dart';

class ObtainedItem {
  final IconData icon;
  final String name;

  ObtainedItem({required this.icon, required this.name});

  factory ObtainedItem.fromJson(Map<String, dynamic> json) {
    return ObtainedItem(
      icon: _mapStringToIconData(json['icon']),
      name: json['name'],
    );
  }

  static IconData _mapStringToIconData(String iconName) {
    switch (iconName) {
      case 'spa':
        return Icons.spa;
      case 'grass':
        return Icons.grass;
      case 'eco':
        return Icons.eco;
      case 'local_florist':
        return Icons.local_florist;
      case 'water':
        return Icons.water;
      default:
        return Icons.help_outline;
    }
  }
}
