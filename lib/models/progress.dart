// lib/models/progress.dart

import 'achievement.dart';
import 'item.dart';

class Progress {
  final List<Achievement> achievements;
  final List<Item> items;
  final int points;

  Progress({
    required this.achievements,
    required this.items,
    required this.points,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      achievements: json['achievements'] != null
          ? (json['achievements'] as List<dynamic>)
              .map((a) => Achievement.fromJson(a))
              .toList()
          : [],
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((i) => Item.fromJson(i))
              .toList()
          : [],
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'items': items.map((i) => i.toJson()).toList(),
      'points': points,
    };
  }
}
