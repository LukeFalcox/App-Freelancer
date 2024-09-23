import 'package:app_freelancer/app/pages/freelancer/home/home_profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatefulWidget {
  final AuthService authService;
  const Home({
    super.key,
    required this.authService,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseAuth _auth;
  late User? user;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    userEmail = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    const categories = [
      "All",
      "Breakfast",
      "Lunch",
      "Dinner",
    ];
    String currentCat = "All";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.notifications),
            // Corrigido estilo incorreto de IconButton.
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Novos Projetos para você",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 20), // Ajuste para espaçamento
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: const Row(
                  children: [
                    Icon(Ionicons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search any recipes",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Ajuste para espaçamento
              Container(
                width: double.infinity,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("image/img/carousel01.png")),
                ),
              ),
              const SizedBox(height: 20), // Ajuste para espaçamento
              const Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: List.generate(
                  categories.length,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: currentCat == categories[index]
                          ? const Color(0xff568A9F)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: currentCat == categories[index]
                            ? Colors.white
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quick & Fast",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View all")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: List.generate(

              //     ),
              //   ),
              // ),
              SingleChildScrollView(
                child: FutureBuilder<List<Map<String, dynamic>>?>(
                  future: widget.authService
                      .getprojectsorfreelancers("All", userEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erro ao carregar informações.'));
                    }
                    if (snapshot.hasData) {
                      final List<Map<String, dynamic>>? userInfoList =
                          snapshot.data;
                      if (userInfoList == null || userInfoList.isEmpty) {
                        return const Center(
                            child: Text('Nenhum projeto encontrado.'));
                      }

                      // Constrói a ListView.builder na horizontal
                      // Constrói a ListView.builder na horizontal
                      return SizedBox(
                        height:
                            250, // Altura definida para o ListView horizontal
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Define a direção da rolagem
                          itemCount: userInfoList.length,
                          itemBuilder: (context, index) {
                            final userInfo = userInfoList[index];
                            final emailCli = userInfo['emailcli'];

                            return FutureBuilder<Map<String, dynamic>>(
                              future: widget.authService.getClientInfo(
                                  emailCli), // Combina as funções getname e getnota
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text(
                                          'Erro ao carregar informações.'));
                                }
                                if (snapshot.hasData && snapshot.data != null) {
                                  final clientData = snapshot.data!;
                                  final name = clientData['name'] ??
                                      'Nome Desconhecido'; // Verificação do nome
                                  final nota = clientData['nota'] ??
                                      [0]; // Verificação da nota

                                  return UserCard(
                                    name: name,
                                    rating: nota,
                                    classification:
                                        userInfo['classification'] ?? [],
                                  );
                                }

                                return const Text(
                                    'Informações não disponíveis.');
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const Center(child: Text('Nenhum dado disponível.'));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {

  final String name;
  final List<dynamic> rating;
  final List classification;

  UserCard({
    required this.name,
    required this.rating,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      width: 150, // Define a largura fixa
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/default_avatar.png')
                    as ImageProvider, // Verificação se a URL da imagem está vazia
          ),
          const SizedBox(height: 10),
          Text(
            name.isNotEmpty ? name : 'Nome Desconhecido', // Validação do nome
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: classification.map((language) {
              return Chip(
                label: Text(language),
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StarBar(rating: rating,size: 14,), // Verificação de rating
            ],
          ),
        ],
      ),
    );
  }
}
