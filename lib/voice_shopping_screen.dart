import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'widgets/manual_input_field.dart';
import 'screens/product_grid_screen.dart';

class VoiceShoppingScreen extends StatefulWidget {
  const VoiceShoppingScreen({super.key});

  @override
  State<VoiceShoppingScreen> createState() => _VoiceShoppingScreenState();
}

class _VoiceShoppingScreenState extends State<VoiceShoppingScreen> {
  late stt.SpeechToText _speech;
  bool _listening = false;
  String _spoken = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!_listening) {
      bool available = await _speech.initialize(
        onStatus: (status) => debugPrint('Status: $status'),
        onError: (error) => debugPrint('Error: $error'),
      );
      if (available) {
        setState(() => _listening = true);
        _speech.listen(
          onResult: (result) async {
            if (result.finalResult) {
              setState(() {
                _spoken = result.recognizedWords;
                _listening = false;
              });
              await _searchAndAdd(_spoken);
              _speech.stop();
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _listening = false);
    }
  }

  Future<void> _searchAndAdd(String spokenText) async {
    final words = spokenText.toLowerCase().split(RegExp(r'\s+'));
    final productsRef = FirebaseFirestore.instance.collection('products');
    final cart = Provider.of<CartProvider>(context, listen: false);

    for (final word in words) {
      final snapshot = await productsRef.where('name', isEqualTo: word).get();
      for (final doc in snapshot.docs) {
        final product = doc.data();
        cart.addToCart(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Voice Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColor,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🎙️ Voice command section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Speak to shop',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _listen,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _listening
                            ? theme.primaryColor.withOpacity(0.2)
                            : theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _listening
                              ? theme.primaryColor
                              : theme.primaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 48,
                        color: _listening
                            ? theme.primaryColor
                            : theme.primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _listening
                        ? 'Listening...'
                        : _spoken.isNotEmpty
                            ? '"$_spoken"'
                            : 'Tap the mic and say what you need',
                    style: TextStyle(
                      fontSize: 18,
                      color: _listening ? theme.primaryColor : Colors.grey[600],
                      fontStyle: _spoken.isEmpty ? FontStyle.italic : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_listening)
                    const Text(
                      'Processing your request...',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),

            // 📝 Manual input section
            Column(
              children: [
                Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ManualInputField(
                  onSearch: _searchAndAdd,
                  decoration: InputDecoration(
                    hintText: 'Type product name...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    suffixIcon: Icon(Icons.search, color: theme.primaryColor),
                  ),
                ),
              ],
            ),

            // 📦 Browse button
            const SizedBox(height: 20),
            OutlinedButton.icon(
              icon: const Icon(Icons.grid_view),
              label: const Text('Browse All Products'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(color: theme.primaryColor),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductGridScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
