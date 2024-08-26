import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:flutter/material.dart';

class FreelancersCards extends StatefulWidget {
  final AuthService authService;
  const FreelancersCards({super.key, required this.authService});

  @override
  State<FreelancersCards> createState() => _FreelancersCardsState();
}

class _FreelancersCardsState extends State<FreelancersCards> {
  int cards = 2;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: firestore.collection('freelancers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum trabalho localizado.'));
        }

        final freelancers = snapshot.data!.docs;

        return Column(
          children: List.generate(
            cards < freelancers.length ? cards : freelancers.length,
            (index) {
              final free = freelancers[index];
              final nome = free['nome'];
              final tipo = free['tipo'] ?? 'Sem Tipo';
              final media = free['media'] ?? 'Sem Valor';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome,
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Classificação: $tipo',
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Valor Mínimo: $media',
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 8.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _showProjectDetailsDialog(context, free);
                            },
                            child: const Text('Ver Detalhes'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showProjectDetailsDialog(
      BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> free) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detalhes do Projeto',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                free['nome'],
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17A2B8),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${free['desc']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                },
                child: const Text('Conversar com o Freelancer'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
