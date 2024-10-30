import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/ActiveChats.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/RecentChats.dart';
import 'package:flutter/material.dart';

class HomepageChat extends StatelessWidget {
  final bool freeorcli;

  const HomepageChat({super.key, required this.freeorcli});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Mensagens",
          style: TextStyle(
            color: Color(0xFF113953),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 295,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Pesquisar",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      color: Color(0xFF113953),
                    ),
                  ],
                ),
              ),
            ),
            const Activechats(),
            const SizedBox(height: 20),
            Recentchats(freeorcli: freeorcli), // Corrigido aqui
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicione a ação para o botão flutuante aqui
        },
        backgroundColor: const Color(0xFF113953),
        child: const Icon(Icons.message),
      ),
    );
  }
}
