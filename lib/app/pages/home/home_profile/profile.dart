import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/start_screen_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _friendsCollections =
      FirebaseFirestore.instance.collection('friends');


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
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildUser(user),
    );
  }

  Widget _buildUser(User? user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userCollection.doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No data');
        }

        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
               Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(children: [
                  Text(
                    'ABOUT ACCOUNT',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  ),
                  IconButton(
                      onPressed: () {
                        signOut();
                      },
                      icon: Icon(Ionicons.arrow_back_circle))
                ]),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpjVJy6N_yrsojuApPjeUgZMP8W-O000jpVgRhVJdkyg&s'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${userData['username']}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                            Text(
                              '${userData['email']}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'My Friends',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: 600,
                width: 800,
                color: Colors.transparent,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        )),
                    child: Column(
                      children: <Widget>[],
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildListFriends() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _friendsCollections.doc().snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No data');
        }

        Map<String, dynamic> friendData =
            snapshot.data!.data() as Map<String, dynamic>;
        return ListView();
      },
    );
  }
}
