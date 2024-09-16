import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandingTextForm extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;

  const ExpandingTextForm({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText, 
  });

  @override
  _ExpandingTextFormState createState() => _ExpandingTextFormState();
}

class _ExpandingTextFormState extends State<ExpandingTextForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateHeight);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateHeight);
    widget.controller.dispose();
    super.dispose();
  }

  void _updateHeight() {
    // Atualiza o estado quando necessário
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: GoogleFonts.robotoMono(fontSize: 20)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: null, // Permite múltiplas linhas
            minLines: 1, // Define o número mínimo de linhas
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              contentPadding: EdgeInsets.all(8), // Adiciona um pouco de padding interno
            ),
          ),
        ),
      ],
    );
  }
}
