// lib/models/challenge.dart

import 'dart:async';

class Challenge {
  final String id;
  final String title;
  final String description;
  final Reward reward;
  final Achievement? achievement;
  final String type;
  final int? target; // For 'count' type
  final int? duration; // In seconds, for 'time' or 'action' types
  final int? timeLimit; // Specific to 'action' type
  final String? icon; // Added to match backend seed data
  bool isAccepted;
  bool isCompleted;
  double progress; // Changed to double for fractional progress
  DateTime? startTime;
  Timer? timer; // For managing countdowns
  bool isPaused; // Indicates if the challenge is paused
  int? current; // Current count for 'count' type
  int? elapsed; // Elapsed time when paused

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    this.achievement,
    required this.type,
    this.target,
    this.duration,
    this.timeLimit,
    this.icon,
    this.isAccepted = false,
    this.isCompleted = false,
    this.progress = 0.0,
    this.startTime,
    this.timer,
    this.isPaused = false,
    this.current,
    this.elapsed,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      reward: Reward.fromJson(json['reward']),
      achievement: json['achievement'] != null ? Achievement.fromJson(json['achievement']) : null,
      type: json['type'],
      target: json['target'],
      duration: json['duration'],
      timeLimit: json['timeLimit'],
      icon: json['icon'],
      isAccepted: json['isAccepted'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      isPaused: json['isPaused'] ?? false,
      current: json['current'],
      elapsed: json['elapsed'],
      // timer is managed locally and not part of JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'reward': reward.toJson(),
      'achievement': achievement?.toJson(),
      'type': type,
      'target': target,
      'duration': duration,
      'timeLimit': timeLimit,
      'icon': icon,
      'isAccepted': isAccepted,
      'isCompleted': isCompleted,
      'progress': progress,
      'startTime': startTime?.toIso8601String(),
      'isPaused': isPaused,
      'current': current,
      'elapsed': elapsed,
      // timer is excluded from JSON serialization
    };
  }
}

class Reward {
  final String type;
  final dynamic value;

  Reward({required this.type, required this.value});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}

class Achievement {
  final String title;
  final String description;

  Achievement({required this.title, required this.description});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
