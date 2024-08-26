import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ChangeProfileScreen extends StatelessWidget {
  const ChangeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const ChangeProfileBody(),
      ),
    );
  }
}

class ChangeProfileBody extends StatefulWidget {
  const ChangeProfileBody({super.key});

  @override
  _ChangeProfileBodyState createState() => _ChangeProfileBodyState();
}

class _ChangeProfileBodyState extends State<ChangeProfileBody> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _projectsController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _taxaController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  String? uid;
  final picker =  ImagePicker();
  File? _image;

  Future pickImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
  
  


  @override
  Widget build(BuildContext context) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
     uid = user?.uid;
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
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                          ? FileImage(_image!)
                          : null,
                      backgroundColor: Colors.grey, // Não use imagem se _imageFile for nulo
                      child: _image == null
                          ? const Icon(
                              Icons.person, // Ícone padrão de usuário
                              size: 50,
                              color: Colors.white,
                            )
                          : null, // Cor de fundo caso não haja imagem
                    ),
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: const TextStyle(color: Color(0xFF17A2B8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF17A2B8)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _summaryController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Resumo',
                    labelStyle: const TextStyle(color: Color(0xFF17A2B8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF17A2B8)),
                ),
              ],
            ),
          ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Projetos Realizados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17A2B8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _projectsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Descreva seus projetos realizados...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Experiencia',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17A2B8)
                  ),),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _expController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Descreva sua experiencia...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Habilidades',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF17A2B8)
                  ),),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _skillsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Descreva sua Habilidades...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Taxa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17A2B8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _taxaController,
                    decoration: InputDecoration(
                      hintText: 'Sua Taxa média...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                     authService.register_info(_nameController.text, _skillsController.text, _projectsController.text, _expController.text, _taxaController.text, _image, uid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()),
                          );
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      'Salvar Alterações',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _projectsController.dispose();
    _skillsController.dispose();
    _summaryController.dispose();
    super.dispose();
  }
}