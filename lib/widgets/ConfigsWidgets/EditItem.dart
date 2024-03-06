import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  final String title;
  final Widget widget;

  const EditItem({
    super.key,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        Expanded(
          flex: 5,
          child: widget,
        ),
      ],
    );
  }
}
