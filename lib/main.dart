
import 'package:flutter/material.dart';
// import 'dart:io';

void main() {   
  runApp(ProfileScreen());
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meu Perfil'),
          backgroundColor: Colors.blue, 
        ),
        body: ProfileBody(),
      ),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  // String _imagePath = '';
  // File? _imageFile;  Adiciona uma variável para armazenar a imagem selecionada

  // Future<void> _getImageFromGallery() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path); // Atualiza a variável de arquivo
  //       _imagePath = pickedFile.path; // Atualiza o caminho da imagem
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  // onTap: _getImageFromGallery,
                  child: const CircleAvatar(
                    radius: 50,
                    // backgroundImage: _imageFile != null
                    //     ? FileImage(_imageFile!)
                    //     : AssetImage(_imagePath) as ImageProvider, // Atualiza o backgroundImage
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  'Nome',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 228, 223, 223),
                  ),
                ),

                const Text(
                  'Email',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 228, 223, 223),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
              
              const Text(
                  'Sobre',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: const EdgeInsets.all(10.0),
                	decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                		border: Border.all(
                      color: Colors.blueGrey,
                      width: 1,
                    ),
                  ),
                  child: const Text(
             				'Texto dentro do retângulo',
          				),
                ),
                const SizedBox(height: 20),
                
              
                const Text(
                  'Projetos Realizados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: const EdgeInsets.all(10.0),
                	decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                		border: Border.all(
                      color: Colors.blueGrey,
                      width: 1,
                    ),
                  ),
                  child: const Text(
             				'Texto dentro do retângulo',
          				),
                ),
                const SizedBox(height: 20),
                
                
                const Text(
                  'Conhecimentos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: const EdgeInsets.all(10.0),
                	decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                		border: Border.all(
                      color: Colors.blueGrey,
                      width: 1,
                    ),
                  ),
                  child: const Text(
             				'Texto dentro do retângulo',
          				),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Avaliação',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

}