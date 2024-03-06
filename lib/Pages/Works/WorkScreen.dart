import 'package:flutter/material.dart';

class Works extends StatelessWidget {
   Works({super.key});
  final List<String> jobs = ['Desenvolvedor Flutter', 'Designer UI/UX', 'Analista de Dados'];

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Trabalhos'),
        ),
        body: ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(jobs[index]),
                subtitle: Text('Descrição do trabalho'),
                onTap: () {
                  // Ação ao clicar no card
                },
              ),
            );
          },
        ),
      ),
    );
  }
}