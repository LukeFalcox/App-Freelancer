import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
          backgroundColor: const Color(0xFF0A6D92),
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
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  String _imagePath = 'assets/foto_perfil.png';
  File? _imageFile;

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: _getImageFromGallery,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : AssetImage(_imagePath) as ImageProvider,
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  const SizedBox(height: 20),
                  const Text(
                    'Conhecimentos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17A2B8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _skillsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Descreva seus conhecimentos...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Avaliação',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17A2B8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ratingController,
                    decoration: InputDecoration(
                      hintText: 'Sua avaliação média...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      
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
    _ratingController.dispose();
    _summaryController.dispose();
    super.dispose();
  }
}