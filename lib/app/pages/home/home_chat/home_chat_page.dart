import 'package:app_freelancer/app/pages/home/home_chat/chat/chat_page.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/start_screen_page.dart';
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
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.singOut();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StartScreenPage(),
        ));
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
        title: const Text('Chats',style: TextStyle(color:  Colors.white),),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout, color: Colors.white,))
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

    if (_auth.currentUser!.email != data['email']) {
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
                            userEmail: data['email'],
                            receiverUserID: data['uid'],
                          )));
            },
          ),
          Divider()
        ],
      );
    } else {
      return Container();
    }
  }
}