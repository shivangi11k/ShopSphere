import 'package:flutter/material.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<String> recommendations = [];

  void fetchRecommendations() {
    setState(() {
      recommendations = [];
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        recommendations = [
          'Recommended: Organic Almond Milk',
          'Recommended: Wireless Earbuds',
          'Recommended: Cozy Sweatshirt',
        ];
      });
    });
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
