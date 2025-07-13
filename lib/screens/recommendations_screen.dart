import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<String> recommendations = [];
  bool isLoading = false;

  Future<void> fetchRecommendations() async {
    setState(() {
      isLoading = true;
      recommendations = [];
    });

    try {
      final String jsonString =
          await rootBundle.loadString('assets/recommendations.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          recommendations = ['Please log in to get personalized recommendations.'];
          isLoading = false;
        });
        return;
      }

      final List<dynamic>? userRecs = data[user.uid];
      if (userRecs != null) {
        setState(() {
          recommendations = userRecs.cast<String>();
        });
      } else {
        setState(() {
          recommendations = ['No recommendations available for your account.'];
        });
      }
    } catch (e) {
      setState(() {
        recommendations = ['Error loading recommendations.'];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade300,
              ),
              child: const Center(
                child: Icon(
                  Icons.recommend,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: fetchRecommendations,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Get Recommendations',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ...recommendations.map(
                (rec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    rec,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
