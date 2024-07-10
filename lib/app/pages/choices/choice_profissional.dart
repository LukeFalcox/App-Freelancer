import 'package:app_freelancer/app/pages/choices/create_of_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

class ChoiceProfissional extends StatefulWidget {
  final UserCredential userCredential;
  const ChoiceProfissional({super.key, required this.userCredential});

  @override
  State<ChoiceProfissional> createState() => _ChoiceProfissionalState();
}

class _ChoiceProfissionalState extends State<ChoiceProfissional> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CreateOCard(
                icon: Ionicons.logo_github,
                title: 'Freelancer',
                subtitle: 'Freelancer',
              ),
              CreateOCard(
                icon: Ionicons.people,
                title: 'Client',
                subtitle: 'Client',
              )
            ],
          ),
        ));
  }
}
