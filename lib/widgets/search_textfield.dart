// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        decoration: InputDecoration(
          hintText: "E.g. Technology",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
