import 'package:app_freelancer/app/pages/home/home_page.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/start_screen_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthStatePage extends StatelessWidget {
  const CheckAuthStatePage({super.key});

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
            return const HomePage();
          } else {
            // O usuário não está autenticado, direcione-o para a tela de login
            return const StartScreenPage();
          }
        }
      },
    );
  }
}
