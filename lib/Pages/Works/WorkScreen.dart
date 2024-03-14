import 'package:app_freelancer/Pages/Cards/CreateOfCards.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    _jobsFuture = widget.authService.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabalhos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final jobs = snapshot.data!;
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      jobs[index]['title'] ?? 'Sem título',
                      style: TextStyle(
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
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Prazo: ${jobs[index]['selectedDay']}/${jobs[index]['selectedMonth']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Proposta Mínima: ${jobs[index]['propostMin']} ~ Proposta Máxima: ${jobs[index]['propostMax']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
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
                ));
          },
          icon: const Icon(Icons.card_membership_sharp),
        ),
      ),
    );
  }
}
