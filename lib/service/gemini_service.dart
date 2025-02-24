import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schedule_app/models/task.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=';
  final String apikey;
  GeminiService() : apikey = dotenv.env['GEMINI_API_KEY'] ?? '' {
    if (apikey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set');
    }
  }
  Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks);
    final String prompt = _buildPrompt(tasks);

    try {
      print("prompt: \n $prompt");
      final response = await http.post(
        Uri.parse("$_baseUrl$apikey"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [{
            "role": "user",
            "parts":[{"text": prompt}]
          }]
        }));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to generate schedule: $e');
    }
  }

  String _handleResponse(http.Response response) {
  final data = jsonDecode(response.body);
  if (response.statusCode == 401) {
    throw Exception('API key is invalid');
  } else if (response.statusCode == 429) {
    throw Exception('API key is rate limited');
  } else if (response.statusCode == 500) {
    throw Exception('Internal server error');
  } else if (response.statusCode == 503) {
    throw Exception('Service unavailable');
  } else if (response.statusCode == 200) {
    // final data = jsonDecode(response.body);
    return data['contents'][0]['parts'][0]['text'];
  } else {
    throw Exception('Failed to generate schedule');
  }
  }


  String _buildPrompt(List<Task> tasks) {
    final taskList = tasks.map((task) => '- ${task.name} (Priority: ${task.priority}) (Duration: ${task.duration}) (Deadline: ${task.deadline})').join('\n');
    return 'Generate a schedule for the following tasks:\n$taskList';
  }


  void _validateTasks(List<Task> tasks) {
    if (tasks.isEmpty) {
      throw Exception('No tasks provided');
    }
  }
}