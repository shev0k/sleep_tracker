// lib/models/reward.dart

import 'item.dart';

class Reward {
  final String type; // 'points' or 'item'
  final dynamic value; // int for points, Item for items

  Reward({
    required this.type,
    required this.value,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'points') {
      return Reward(
        type: json['type'],
        value: json['points'],
      );
    } else if (json['type'] == 'item') {
      return Reward(
        type: json['type'],
        value: Item.fromJson(json['item']),
      );
    } else {
      throw Exception('Unknown reward type: ${json['type']}');
    }
  }

  @override
  String toString() {
    if (type == 'points') {
      return "$value points";
    } else if (type == 'item' && value is Item) {
      return "${value.name}";
    } else {
      return "Unknown Reward";
    }
  }

  Map<String, dynamic> toJson() {
    if (type == 'points') {
      return {
        'type': type,
        'points': value,
      };
    } else if (type == 'item') {
      return {
        'type': type,
        'item': (value as Item).toJson(),
      };
    } else {
      throw Exception('Unknown reward type: $type');
    }
  }
}
