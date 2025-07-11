import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../cart_provider.dart';

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Products')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              final product = products[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () => cart.addToCart(product),
                child: Card(
                  child: Column(
                    children: [
                      Expanded(child: Image.network(product['image_url'], fit: BoxFit.cover)),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text('₹${product['price']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
