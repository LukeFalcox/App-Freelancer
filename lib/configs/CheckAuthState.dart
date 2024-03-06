import 'package:app_freelancer/Pages/Homes/HomeScreen.dart';
import 'package:app_freelancer/Pages/Homes/StartScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthState extends StatelessWidget {
  const CheckAuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            // O usuário está autenticado, direcione-o para a tela principal
            return const HomeScreen();
          } else {
            // O usuário não está autenticado, direcione-o para a tela de login
            return const StartScreen();
          }
        }
      },
    );
  }
}
