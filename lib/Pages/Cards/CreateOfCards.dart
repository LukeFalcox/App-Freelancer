import 'package:app_freelancer/Pages/Homes/HomeScreen.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CardCreate extends StatefulWidget {
  const CardCreate({Key? key}) : super(key: key);

  @override
  State<CardCreate> createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  int? _selectedDay;
  int? _selectedMonth;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  // final TextEditingController _userController = TextEditingController();
  final TextEditingController _minProstController = TextEditingController();
  final TextEditingController _maxProstController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chats',style: TextStyle(color:  Colors.white),),
        iconTheme: const IconThemeData(
            color: Colors.white, // Defina a cor desejada aqui
          ),
      ),
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 550,
                height: 600,
                color: const Color.fromARGB(218, 65, 62, 62),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 25, 40, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 300,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Name of Service',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      width: 3,
                                      color: Color(0xFF5F16B8),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      width: 3,
                                      color: Color(0xFF1B93F5),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      width: 3,
                                      color: Color.fromARGB(255, 95, 90, 90),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width:
                                250, // Alterado para ocupar toda a largura disponível
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Alinhado à esquerda
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: _descController,
                                    maxLines:
                                        12, // Permite múltiplas linhas de texto
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Color(0xFF5F16B8),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Color(0xFF1B93F5),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Color(0xFFF73123),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // Altere para a cor desejada de fundo
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                  'Day:',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownButton<int>(
                                value: _selectedDay,
                                items: _buildDropdownItemsDay(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDay = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // Altere para a cor desejada de fundo
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Text(
                                  'Month:',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              DropdownButton<int>(
                                value: _selectedMonth,
                                items: _buildDropdownItemsMonth(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMonth = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 135,
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _minProstController,
                              decoration: InputDecoration(
                                labelText: 'Propost-Min',
                                labelStyle: const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 3,
                                    color: Color(0xFF5F16B8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 3,
                                    color: Color(0xFF1B93F5),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 3,
                                    color: Color(0xFFF73123),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 135,
                          child: TextField(
                            controller: _maxProstController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Propost-Max',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 3,
                                  color: Color(0xFF5F16B8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 3,
                                  color: Color(0xFF1B93F5),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 3,
                                  color: Color(0xFFF73123),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue), // Cor de fundo do botão
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 24),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Borda arredondada
                              ),
                            ),
                          ),
                          child: const Text(
                            'Confirmar',
                            style: TextStyle(
                              color: Colors.white, // Cor do texto
                              fontSize: 16, // Tamanho da fonte
                              fontWeight: FontWeight.bold, // Peso da fonte
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
              
               final authService = Provider.of<AuthService>(context, listen: false);
                        
              try {
                 authService.registerCard(
                                  _titleController.text,
                                  _descController.text,
                                  _minProstController.text,
                                  _maxProstController.text,
                                  _selectedDay!,
                                  _selectedMonth!);
              
                        
                        Navigator.pop(context);
                        
                        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  List<DropdownMenuItem<int>> _buildDropdownItemsDay() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i <= 31; i++) {
      items.add(DropdownMenuItem<int>(
        value: i,
        child: Text('$i'),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> _buildDropdownItemsMonth() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i <= 12; i++) {
      items.add(DropdownMenuItem<int>(
        value: i,
        child: Text('$i'),
      ));
    }
    return items;
  }
}
