import 'package:app_freelancer/app/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app/pages/homeprincip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class CheckAuthState extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

   CheckAuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _auth.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostrar um indicador de carregamento enquanto aguarda a autenticação
            return const CircularProgressIndicator();
          } else {
            // Se o usuário estiver autenticado, vá para a tela principal
            if (snapshot.hasData && snapshot.data != null) {
              return const HomePage();
            } else {
              // Caso contrário, vá para a tela de login
              return const HomePrincip();
            }
          }
        },
      ),
    );
  }
}