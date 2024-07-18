import 'package:flutter/material.dart';

class NovaPagina extends StatelessWidget {
  const NovaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Página'),
      ),
      body: const Center(
        child: Text(
          'Esta é uma página fictícia para teste de redirecionamento.',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}