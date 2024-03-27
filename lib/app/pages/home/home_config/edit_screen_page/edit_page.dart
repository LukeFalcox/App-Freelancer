
import 'package:app_freelancer/app/pages/widgets/configs_widgets/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class AboutAccount extends StatefulWidget {
  const AboutAccount({super.key});

  @override
  State<AboutAccount> createState() => _AboutAccountState();
}

class _AboutAccountState extends State<AboutAccount> {
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
          children: [
            Text("ABOUT ACCOUNT", style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
