// ignore_for_file: prefer_const_constructors

import 'package:app_freelancer/app/pages/home/home_chat/chat/chat_page.dart';
import 'package:app_freelancer/app/pages/home/works/create_of_cards/create_of_cards_page.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Works extends StatefulWidget {
  final AuthService authService;

  const Works({Key? key, required this.authService}) : super(key: key);

  @override
  _WorksState createState() => _WorksState();
}

class _WorksState extends State<Works> {
  late Future<List<Map<String, dynamic>>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = widget.authService.get_data();
  }

@override
Widget build(BuildContext context) {
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Trabalhos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.authService.get_data(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Nenhum trabalho encontrado.'));
        } else {
          final jobs = snapshot.data!;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color.fromARGB(255, 95, 95, 95),
                child: ListTile(
                  title: Text(
                    jobs[index]['title'] ?? 'Sem título',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          jobs[index]['desc'] ?? 'Sem descrição',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Prazo: ${jobs[index]['selectedDay']}/${jobs[index]['selectedMonth']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Proposta Mínima: ${jobs[index]['propostMin']} ~ Proposta Máxima: ${jobs[index]['propostMax']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Conversar com Cliente:",
                              style: TextStyle(color: Colors.black),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (currentUserID == jobs[index]['uid']) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Aviso'),
                                        content: Text(
                                            'O usuário que fez a requisição do serviço não pode aceitá-lo, somente removê-lo.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  final authservice = Provider.of<AuthService>(
                                      context,
                                      listen: false);

                                  authservice.register_friends(
                                      currentUserID, jobs[index]['uid']);
                                  setState(() {
                                    _jobsFuture = widget.authService.get_data();
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        receiverUserID: jobs[index]['uid'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Ionicons.heart),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CardCreate(),
            ),
          );
        },
        icon: const Icon(Icons.card_membership_sharp),
      ),
    ),
  );
}
}
