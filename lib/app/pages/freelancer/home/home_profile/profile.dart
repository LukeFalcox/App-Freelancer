import 'dart:io';
import 'package:app_freelancer/app/pages/freelancer/home/home_profile/changeProfile.dart';
import 'package:app_freelancer/app/pages/freelancer/home/start_screen_page/sign/login_page.dart';
import 'package:app_freelancer/app/pages/freelancer/home/start_screen_page/sign/register_page.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Certifique-se de que o caminho da importação está correto

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Meu Perfil',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 30, 81, 250),
        ),
        body: _buildProfile(user),
      ),
    );
  }

  Widget _buildProfile(User? user) {
    Provider.of<AuthService>(context, listen: false);

    File? imageFile;


    if (user != null) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text('Error');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading...');
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text('No data');
      }

      final doc = snapshot.data!.docs.first;
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data == null) {
        return const Text('Unexpected null value');
      }

      final String name = data['nome'] ?? 'Sem Nome';
      final String email = data['email'] ?? 'Sem Email';
      final String summary = data['summarry'] ?? 'Nenhuma Habilidade Informada';
      final String projects = data['projects'] ?? 'Nenhum Projeto Informado';
      final String skills = data['skills'] ?? 'Nenhuma Experiência Informada';
      final String rating = data['rating'] ?? 'Nenhuma Avaliação';
      final String taxa = data['taxa'] ?? 'Nenhuma Taxa Informada';

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile)
                          : null,
                      backgroundColor: Colors.grey, // Não use imagem se _imageFile for nulo
                      child: imageFile == null
                          ? const Icon(
                              Icons.person, // Ícone padrão de usuário
                              size: 50,
                              color: Colors.white,
                            )
                          : null, // Cor de fundo caso não haja imagem
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoSessao('Nome', name),
                      infoSessao('Email', email),
                      infoSessao('Habilidades', summary),
                      infoSessao('Projetos Realizados', projects),
                      infoSessao('Experiencia', skills),
                      infoSessao('Avaliação', rating),
                      infoSessao('Taxa', taxa),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangeProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text(
                          'Alterar informações',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
 else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Faça login para poder usar o app.",
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const PageLogin()));
                },
                child: const Text('Fazer Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Register()));
                },
                child: const Text('Criar Conta'),
              ),
            ],
          )
        ],
      );
    }
  }

  Widget infoSessao(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF17A2B8),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity, // Define a largura máxima disponível
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
