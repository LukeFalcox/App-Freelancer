import 'package:flutter/material.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';

class CheckboxWidget extends StatefulWidget {
  final List<String> items;
  final List<dynamic> initialSelectedItems;
  final AuthService authservice;
  final String email;
  final Function(List<String>) onSelectionChanged; // Novo callback

  const CheckboxWidget({
    super.key,
    required this.items,
    required this.authservice,
    required this.email,
    required this.onSelectionChanged, // Callback obrigatório
    this.initialSelectedItems = const [],
  });

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  late Map<int, bool> _selectedCheckboxes;

  @override
  void initState() {
    super.initState();
    // Inicializa o estado dos checkboxes com base em initialSelectedItems
    _selectedCheckboxes = {
      for (int index = 0; index < widget.items.length; index++)
        index: widget.initialSelectedItems.contains(widget.items[index]),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;
        return CheckboxListTile(
          title: Text(item),
          value: _selectedCheckboxes[index] ?? false, // Garante que o valor não seja nulo
          onChanged: (bool? value) {
            setState(() {
              _selectedCheckboxes[index] = value ?? false;
              // Extrai os itens selecionados e os passa de volta para o widget pai
              final selectedItems = _selectedCheckboxes.entries
                  .where((element) => element.value)
                  .map((e) => widget.items[e.key])
                  .toList();
              widget.onSelectionChanged(selectedItems);
            });
          },
        );
      }).toList(),
    );
  }
}
