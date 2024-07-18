import 'package:flutter/material.dart';
import 'cards.dart';
import 'nova_pagina.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(builder: (context) => const NovaPagina()),
                  );
                },
                child: const CardWidget(
                  title: 'Freelancer',
                  description: 'Entre na sua conta de freelancer.',
                  color: Color(0xFFEEEEEE),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(builder: (context) => const NovaPagina()),
                  );
                },
                child: const CardWidget(
                  title: 'Cliente',
                  description: 'Entre na sua conta de cliente.',
                  color: Color(0xFFEEEEEE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}