import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/chat_page.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app/pages/freelancer/home/start_screen_page/sign/login_page.dart';
import 'package:app_freelancer/app/pages/freelancer/home/start_screen_page/sign/register_page.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePageChat extends StatefulWidget {
  const HomePageChat({super.key});

  @override
  State<HomePageChat> createState() => _HomePageChatState();
}

class _HomePageChatState extends State<HomePageChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Set<String> _addedUsers = {}; // Conjunto de uid dos usuários já adicionados

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.singOut();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User ? user = _auth.currentUser;
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "Pré-Chat",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
      ),
      body: _buildUserList(user),
    );
  }

  Widget _buildUserList(User? user) {
    if (user != null) {
      return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('friends').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }

        if (snapshot.data == null) {
          return const Text('No data');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
    } else {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PageLogin()));
            },
            child: const Text('Fazer Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
            },
            child: const Text('Criar Conta'),
          ),
          ],)
        ],
      );
    }
    
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Verificar se o uid do cliente não está repetido
    if (!_addedUsers.contains(data['uidclient']) &&
        _auth.currentUser!.uid != data['uidclient']) {
      _addedUsers.add(data['uidclient']); // Adicionar uid à lista de usuários adicionados

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(data['uidclient']).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Text('Erro ao carregar usuário');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('Usuário não encontrado');
          }

          Map<String, dynamic> userData = snapshot.data!.data()! as Map<String, dynamic>;

          return Column(
            children: [
              ListTile(
                title: Text(
                  userData['name'],
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserID: data['uidclient'],
                      ),
                    ),
                  );
                },
              ),
              const Divider()
            ],
          );
        },
      );
    } else {
      return Container(); // Retornar um container vazio para usuários repetidos
    }
  }
}



/*

 return Column(
        children: [
          ListTile(
            title: Text(
              data['username'],
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            receiverUserID: data['uid'],
                          )));
            },
          ),
          Divider()
        ],
      );

*/