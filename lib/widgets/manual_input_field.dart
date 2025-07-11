import 'package:flutter/material.dart';

class ManualInputField extends StatelessWidget {
  final void Function(String) onSearch;
  final InputDecoration? decoration; 

  const ManualInputField({super.key, required this.onSearch, this.decoration});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Type items like "milk bread"',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            final input = controller.text.trim();
            if (input.isNotEmpty) {
              onSearch(input);
              controller.clear();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
