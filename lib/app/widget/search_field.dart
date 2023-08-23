
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextField(
        readOnly: true,
        style: const TextStyle(
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              width: 0.0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search...',
        ),
      ),
    );
  }
}

