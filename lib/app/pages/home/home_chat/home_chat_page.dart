import 'package:app_freelancer/app/pages/home/home_chat/chat/chat_page.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/start_screen_page.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePageChat extends StatefulWidget {
  const HomePageChat({Key? key}) : super(key: key);

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
        builder: (context) => const StartScreenPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
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
            return Text('Erro ao carregar usuário');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('Usuário não encontrado');
          }

          Map<String, dynamic> userData = snapshot.data!.data()! as Map<String, dynamic>;

          return Column(
            children: [
              ListTile(
                title: Text(
                  userData['username'],
                  style: TextStyle(color: Colors.white),
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
              Divider()
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