// lib/services/challenge_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleeping_tracker_ui/models/(challenge)/challenge.dart';
import 'base_url.dart';

class ChallengeService {
  final String baseUrl = UrlString.baseUrl;

  /// Fetch all challenges (Daily Challenges)
  Future<List<Challenge>> getAllChallenges() async {
    final response = await http.get(Uri.parse('$baseUrl/challenges'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Challenge.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load challenges: ${response.body}');
    }
  }

  /// Fetch active challenges (Ongoing Challenges)
  Future<List<Challenge>> getActiveChallenges() async {
    final response = await http.get(Uri.parse('$baseUrl/challenges/active'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Challenge.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load active challenges: ${response.body}');
    }
  }

  /// Fetch completed challenges
  Future<List<Challenge>> getCompletedChallenges() async {
    final response = await http.get(Uri.parse('$baseUrl/challenges/completed'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Challenge.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load completed challenges: ${response.body}');
    }
  }

  /// Fetch a specific challenge by ID
  Future<Challenge> getChallengeById(String challengeId) async {
    final response = await http.get(Uri.parse('$baseUrl/challenges/$challengeId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Challenge.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Challenge not found');
    } else {
      throw Exception('Failed to load challenge: ${response.body}');
    }
  }

  /// Create a new challenge
  Future<Challenge> createChallenge(Challenge challenge) async {
    final response = await http.post(
      Uri.parse('$baseUrl/challenges'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(challenge.toJson()),
    );

    if (response.statusCode == 201) {
      return Challenge.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create challenge: ${response.body}');
    }
  }

  /// Update a challenge (e.g., accept, progress, complete)
  Future<Challenge> updateChallenge(String challengeId, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/challenges/$challengeId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Challenge not found');
    } else {
      throw Exception('Failed to update challenge: ${response.body}');
    }
  }

  /// Delete a challenge
  Future<void> deleteChallenge(String challengeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/challenges/$challengeId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Successfully deleted
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Challenge not found');
    } else {
      throw Exception('Failed to delete challenge: ${response.body}');
    }
  }

  /// Accept a challenge (sets isAccepted to true and initializes startTime)
  Future<Challenge> acceptChallenge(String challengeId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/challenges/$challengeId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'isAccepted': true,
        'startTime': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Challenge not found');
    } else {
      throw Exception('Failed to accept challenge: ${response.body}');
    }
  }

  /// Update progress for a challenge (e.g., current steps, progress fraction)
  Future<Challenge> updateProgress(String challengeId, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/challenges/$challengeId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      return Challenge.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Challenge not found');
    } else {
      throw Exception('Failed to update challenge: ${response.body}');
    }
  }

  /// Complete a challenge (sets isCompleted to true)
  Future<void> completeChallenge(String challengeId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/challenges/$challengeId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isCompleted': true}),
    );

    if (response.statusCode == 200) {
      // Successfully completed
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Challenge not found');
    } else {
      throw Exception('Failed to complete challenge: ${response.body}');
    }
  }
}
