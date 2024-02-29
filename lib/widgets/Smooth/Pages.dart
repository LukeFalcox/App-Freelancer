import 'package:app_freelancer/widgets/Gradient/GradiendText.dart';
import 'package:flutter/material.dart';

class Pages extends StatelessWidget {
  const Pages(
      {super.key,
      required this.title,
      required this.text,
      required this.colors1,
      required this.colors2});

  final String title;
  final String text;
  final Color colors1;
  final Color colors2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Color.fromARGB(255, 99, 10, 182),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          text: title,
                          gradient: LinearGradient(colors: [colors1, colors2]),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
