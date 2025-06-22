import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIDietPlannerScreen extends StatefulWidget {
  const AIDietPlannerScreen({super.key});

  @override
  State<AIDietPlannerScreen> createState() => _AIDietPlannerScreenState();
}

class _AIDietPlannerScreenState extends State<AIDietPlannerScreen> {
  String _dietPlan = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadDietPlan();
  }

  Future<void> _loadDietPlan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dietPlan = prefs.getString('diet_plan') ?? '';
    });
  }

  Future<void> _generateDietPlan() async {
    setState(() => _loading = true);

    try {
      final apiKey = dotenv.env['OPENROUTER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Missing OpenRouter API Key.");
      }

      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://yourapp.com', // Optional
          'X-Title': 'FitMate AI Diet Planner',  // Optional
        },
        body: jsonEncode({
          "model": "mistralai/mistral-7b-instruct",
          "messages": [
            {
              "role": "user",
              "content":
                  "Create a short 1-day diet plan in bullet points for someone who wants to stay healthy and fit. Keep it concise and clear."
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final plan = data['choices'][0]['message']['content'] ?? "No plan.";

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('diet_plan', plan);

        setState(() {
          _dietPlan = plan;
        });
      } else {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        setState(() => _dietPlan = "Failed: ${response.body}");
      }
    } catch (e) {
      setState(() => _dietPlan = "Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: SafeArea(
          child: Column(
            children: [
              const Text(
                "AI Diet Planner",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Text(
                            _dietPlan.isEmpty
                                ? "No diet plan yet.\nTap the button to generate one!"
                                : _dietPlan,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _generateDietPlan,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Text(
                    "Generate Plan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
