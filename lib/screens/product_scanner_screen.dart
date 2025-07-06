import 'package:flutter/material.dart';

class ProductScannerScreen extends StatefulWidget {
  const ProductScannerScreen({super.key});

  @override
  State<ProductScannerScreen> createState() => _ProductScannerScreenState();
}

class _ProductScannerScreenState extends State<ProductScannerScreen> {
  String scannedProduct = 'None';

  void startScanning() {
    // Simulate scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        scannedProduct = 'Sample Product (Detected)';
      });
    });

    setState(() {
      scannedProduct = 'Scanning...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Scanner'),
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
                  Icons.camera_alt,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: startScanning,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Start Scanning',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Detected Product: $scannedProduct',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
