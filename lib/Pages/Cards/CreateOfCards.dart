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
              color: Colors.red,
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
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
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
                              const Padding(
                                padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLines:
                                      12, // Permite múltiplas linhas de texto
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(width: 3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                       SizedBox(width: 20,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[200], // Altere para a cor desejada de fundo
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                      SizedBox(width: 20,),
                       Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[200], // Altere para a cor desejada de fundo
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 135,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Propost-Max',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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
