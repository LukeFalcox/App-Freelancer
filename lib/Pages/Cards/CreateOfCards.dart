import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardCreate extends StatefulWidget {
  const CardCreate({Key? key}) : super(key: key);

  @override
  State<CardCreate> createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  int? _selectedDay;
  int? _selectedMonth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
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
                              decoration: InputDecoration(
                            labelText: 'Name of Service',
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
                              // Padding(
                              //   padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                              //   child: Text(
                              //     'Description',
                              //     style: TextStyle(
                              //         fontSize: 14, color: Colors.black),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
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
                                  color: const Color(0xFF1B93F5),
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
                      SizedBox(width: 20,),
                      SizedBox(
                        width: 135,
                        child: TextField(
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
                      SizedBox(width: 120,),
                      TextButton(onPressed: () {}, child: const Text('Confirmar'))
                    ],
                  ),
                ],
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
