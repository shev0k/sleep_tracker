import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

class SleepScoreService {
    final String baseUrl = UrlString.baseUrl;

    Future<int> getTotalScore() async {
        final response = await http.get(Uri.parse('$baseUrl/sleep/totalScore'));

        if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            final double scoreDouble = jsonResponse['totalScore'];
            final int score = scoreDouble.round();
            return score;
        } else {
            throw Exception('Failed to load total score');
        }
    }
}