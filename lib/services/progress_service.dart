// lib/services/progress_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleeping_tracker_ui/models/progress.dart';
import 'base_url.dart'; // Ensure this contains your backend base URL

class ProgressService {
  final String baseUrl = UrlString.baseUrl;

  /// Populates progress based on completed challenges
  Future<Map<String, dynamic>> populateProgress() async {
    final response = await http.post(
      Uri.parse('$baseUrl/progress/populate'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to populate progress: ${response.body}');
    }
  }

  /// Fetches the current progress including achievements and items
  Future<Progress> getProgress() async {
    final response = await http.get(Uri.parse('$baseUrl/progress'));

    if (response.statusCode == 200) {
      return Progress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load progress: ${response.body}');
    }
  }

  /// Adds an achievement to progress
  Future<Progress> addAchievement(String achievementId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/progress/achievements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'achievementId': achievementId}),
    );

    if (response.statusCode == 200) {
      return Progress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add achievement: ${response.body}');
    }
  }

  /// Adds an item to progress
  Future<Progress> addItem(String itemId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/progress/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'itemId': itemId}),
    );

    if (response.statusCode == 200) {
      return Progress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  /// Removes an achievement from progress
  Future<Progress> removeAchievement(String achievementId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/progress/achievements/$achievementId'),
    );

    if (response.statusCode == 200) {
      return Progress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to remove achievement: ${response.body}');
    }
  }

  /// Removes an item from progress
  Future<Progress> removeItem(String itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/progress/items/$itemId'),
    );

    if (response.statusCode == 200) {
      return Progress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to remove item: ${response.body}');
    }
  }

  /// Completes a challenge
  Future<Map<String, dynamic>> completeChallenge(String challengeId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/challenges/$challengeId/complete'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete challenge: ${response.body}');
    }
  }
}
