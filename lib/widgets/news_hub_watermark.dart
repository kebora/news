import 'package:flutter/material.dart';

class NewsHubWaterMark extends StatelessWidget {
  const NewsHubWaterMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "News",
        style: TextStyle(
          fontSize: 95,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}
