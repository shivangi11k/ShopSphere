import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductScannerScreen extends StatefulWidget {
  const ProductScannerScreen({super.key});

  @override
  State<ProductScannerScreen> createState() => _ProductScannerScreenState();
}

class _ProductScannerScreenState extends State<ProductScannerScreen> {
  String resultText = 'Scan a product barcode...';
  List<String> allergies = ["milk", "peanut", "soy"];

  Future<void> fetchProductData(String barcode) async {
    final url = Uri.parse("https://world.openfoodfacts.org/api/v0/product/$barcode.json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == 1) {
        final product = data["product"];
        final name = product["product_name"] ?? "Unknown Product";
        final rawIngredients = product["ingredients_text"] ?? "";
        final ingredients = rawIngredients.toLowerCase().split(RegExp(r'[,\.;]')).map((s) => s.trim()).toList();

        final foundAllergies = allergies.where((allergy) =>
            ingredients.any((ing) => ing.contains(allergy))).toList();

        setState(() {
          resultText = "🛒 $name\n\n🧾 Ingredients:\n$rawIngredients";
          if (foundAllergies.isNotEmpty) {
            resultText += "\n\n🚨 Allergy Alert: Contains ${foundAllergies.join(", ")}";
          } else {
            resultText += "\n\n✅ Safe based on your allergy list.";
          }
        });
      } else {
        setState(() {
          resultText = "❌ Product not found.";
        });
      }
    } else {
      setState(() {
        resultText = "❌ Failed to fetch product data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Barcode Allergy Scanner")),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final code = barcode.rawValue;
                if (code != null) {
                  fetchProductData(code);
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(resultText, style: const TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
