// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_freelancer/app/pages/configs/auth_service.dart';

class CheckboxWidget extends StatefulWidget {
  final List<String> items;
  final List<dynamic> initialSelectedItems; // Lista de itens inicialmente selecionados
  AuthService authservice; 
  String email;

  CheckboxWidget({
    Key? key,
    required this.items,
    required this.authservice,
    required this.email,
    this.initialSelectedItems = const [], // Define lista vazia por padrão
  }) : super(key: key);

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  Map<int, bool> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _selectedItems = Map.fromIterable(
      List.generate(widget.items.length, (index) => index),
      key: (item) => item as int,
      value: (item) => widget.initialSelectedItems.contains(widget.items[item]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      width: 350,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                    widget.items[index],
                    style: const TextStyle(color: Colors.black87),
                  ),
                  value: _selectedItems[index] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedItems[index] = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              widget.authservice.save_classification(
                _selectedItems,
                widget.items,
                widget.email,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 158, 158, 158),
              side: BorderSide.none,
              shape: const StadiumBorder(),
            ),
            child: const Text(
              "Save",
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
