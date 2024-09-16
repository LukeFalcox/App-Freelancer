import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/ChatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Recentchats extends StatefulWidget {
  const Recentchats({super.key});

  @override
  State<Recentchats> createState() => _RecentchatsState();
}

class _RecentchatsState extends State<Recentchats> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Set<String> _addedUsers = {};
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: _buildUserContacts(),
        ),
      ),
    );
  }

  Widget _buildUserContacts() {
    User? user = _auth.currentUser;
    String? email = user?.email;

    return FutureBuilder<List<String>>(
      future: _authService.getcontactsfreelancers(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os chats'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum chat encontrado'));
        }
        return GestureDetector(
          child: ListView(
            children: snapshot.data!
                .map<Widget>(
                    (chatRoomId) => _buildUserListItem(chatRoomId, email))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(String chatRoomId, String? email) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('chat')
          .doc(chatRoomId)
          .collection('users')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar usuários'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum usuário encontrado'));
        }

        return Column(
          children: snapshot.data!.docs.map<Widget>((userDoc) {
            Map<String, dynamic> userData =
                userDoc.data()! as Map<String, dynamic>;

            bool isClient = userData.containsKey('cliente');
            String? targetEmail =
                isClient ? userData['cliente'] : userData['freelancer'];
            String? uid = isClient ? userData['uidcli'] : userData['uidfree'];

            if (!_addedUsers.contains(uid) &&
                _auth.currentUser?.email != targetEmail) {
              _addedUsers.add(uid!);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPageNew(
                        email: targetEmail!,
                        authService: _authService,
                        receiverUserID: uid,
                        chatRoomId: chatRoomId,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.white,
                  height: 65,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<Map<String, dynamic>?>(
                              future: _authService.getInfosUsers(targetEmail),
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
                                if (snapshot.hasData) {
                                  final userInfo = snapshot.data;

                                  return Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userInfo?['nome'] ??
                                              'Nome não disponível',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF113953),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: _authService
                                              .getMessages(chatRoomId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            if (snapshot.hasError) {
                                              return const Center(
                                                  child: Text(
                                                      'Erro ao carregar mensagens.'));
                                            }
                                            if (snapshot.hasData &&
                                                snapshot
                                                    .data!.docs.isNotEmpty) {
                                              final lastMessage =
                                                  snapshot.data!.docs.last;
                                              final formattedTime =
                                                  lastMessage['formattedTime']
                                                      as String;
                                              final timeWithoutSeconds =
                                                  formattedTime.substring(
                                                      0, 5); // "HH:mm"
                                              return Text(
                                                "${email == targetEmail ? userInfo!['nome'] : 'Eu:'} ${lastMessage['message']}",
                                              );
                                            }
                                            return const Center(
                                                child: Text(
                                                    'Nenhuma mensagem encontrada.'));
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const Center(
                                    child: Text(
                                        'Informações do usuário não disponíveis.'));
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: _authService.getMessages(chatRoomId),
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

                                if (snapshot.hasData) {
                                  final messagesdata = snapshot.data!.docs.last;

                                  String formattedTime =
                                      messagesdata['formattedTime'] as String;
                                  String timeWithoutSeconds =
                                      formattedTime.substring(0, 5); // "HH:mm"
                                  return Text("${timeWithoutSeconds}");
                                }

                                return const Center(
                                    child:
                                        Text('Nenhuma mensagem encontrada.'));
                              },
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder<int>(
                              stream: _authService
                                  .countNewMessagesStream(chatRoomId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text(
                                          'Erro ao carregar a contagem de mensagens.'));
                                }
                                if (snapshot.hasData) {
                                  final count = snapshot.data;

                                  if (count != null && count > 0) {
                                    return Container(
                                      height: 23,
                                      width: 23,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF113953),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    );
                                  }
                                }
                                return Container(); // Retorna um container vazio se não houver dados
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container(); // Retorna um container vazio se o usuário já foi adicionado ou é o usuário atual
          }).toList(),
        );
      },
    );
  }
}
