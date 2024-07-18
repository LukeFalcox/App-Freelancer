
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const CardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      color: color,
      child: Container(
        width: 300,
        height: 200,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:  Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color:  Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}