import 'package:flutter/material.dart';

class ARShoppingScreen extends StatefulWidget {
  const ARShoppingScreen({super.key});

  @override
  State<ARShoppingScreen> createState() => _ARShoppingScreenState();
}

class _ARShoppingScreenState extends State<ARShoppingScreen> {
  String arStatus = 'Tap to start AR navigation';

  void startARShopping() {
    setState(() {
      arStatus = 'Activating AR Navigation...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        arStatus = 'AR Navigation Activated!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Shopping Guide'),
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
                  Icons.view_in_ar,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: startARShopping,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Start AR Shopping',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              arStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
