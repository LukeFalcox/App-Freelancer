import 'package:falco_freelancer/home.dart';
import 'package:flutter/material.dart';

class WorksCreate extends StatefulWidget {
  const WorksCreate({super.key});

  @override
  State<WorksCreate> createState() => _WorksCreateState();
}

class _WorksCreateState extends State<WorksCreate> {
  String? uid;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _minProstController = TextEditingController();
  final TextEditingController _maxProstController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro de Trabalhos",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A6D92),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        labelText: 'Título'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        labelText: 'Descrição'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        labelText: 'Classificações'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        labelText: 'Prazo Final'),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 5.0,
                      ),
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _minProstController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              labelText: 'Proposta Mínima'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 5.0,
                      ),
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _maxProstController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              labelText: 'Proposta Máxima'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100, // Altura adicionada para evitar sobreposição do botão
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                elevation: MaterialStateProperty.all<double>(5), // Elevação do botão para sombra
                shadowColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      key: Key('authDialog'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Autenticando...'),
                        ],
                      ),
                    );
                  },
                );

                try {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                } catch (error) {
                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Erro ao autenticar: $error'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
