import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Bem-vindo à tela inicial!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}