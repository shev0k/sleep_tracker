// lib/models/achievement.dart

class Achievement {
  final String id;
  final String title;
  final String description;
  final String? icon;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}
