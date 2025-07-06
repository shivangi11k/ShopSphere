import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ShopSphereApp());
}

class ShopSphereApp extends StatelessWidget {
  const ShopSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopSphere',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
