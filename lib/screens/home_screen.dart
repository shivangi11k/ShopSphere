import 'package:flutter/material.dart';
import 'product_scanner_screen.dart';
import 'ar_shopping_screen.dart';
import 'recommendations_screen.dart';
import 'product_grid_screen.dart';
import '../voice_shopping_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo (Circular Icon)
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Product Scanner Button
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      _fadeRoute(const ProductScannerScreen()),
                    );
                  },
                  child: Text(
                    'Product Scanner',
                    style: buttonTextStyle(),
                  ),
                ),
                const SizedBox(height: 20),

                // Recommendations Button
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      _fadeRoute(const RecommendationsScreen()),
                    );
                  },
                  child: Text(
                    'Recommendations',
                    style: buttonTextStyle(),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Grid Button
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      _fadeRoute(const ProductGridScreen()),
                    );
                  },
                  child: Text(
                    'Product Grid',
                    style: buttonTextStyle(),
                  ),
                ),
                const SizedBox(height: 20),

                // Voice Assistant Button
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    Navigator.of(context).push(
                      _fadeRoute(const VoiceShoppingScreen()),
                    );
                  },
                  child: Text(
                    'Voice Assistant',
                    style: buttonTextStyle(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Button Styling
  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.deepPurple.shade400,
      elevation: 5,
    );
  }

  // Button Text Style
  static TextStyle buttonTextStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  // Smooth Fade Transition
  PageRouteBuilder _fadeRoute(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
