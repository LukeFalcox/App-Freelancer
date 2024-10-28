import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';

class AvaliacaoWidget extends StatefulWidget {
  final String email;
  final AuthService authService;
  final VoidCallback onRatingSubmitted; // Callback

  const AvaliacaoWidget({
    super.key,
    required this.email,
    required this.authService,
    required this.onRatingSubmitted, // Adicione aqui
  });

  @override
  _AvaliacaoWidgetState createState() => _AvaliacaoWidgetState();
}

class _AvaliacaoWidgetState extends State<AvaliacaoWidget> {
  double _avaliacao = 0.0;

  Future<void> _sendRating(double avaliacao) async {
    try {
      await widget.authService.saveNota(widget.email, avaliacao.toString());
    } catch (e) {
      print("Erro ao carregar informações do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Avalie ----',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _avaliacao = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _sendRating(_avaliacao); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Avaliação enviada: $_avaliacao'),
                  ),
                );

                widget.onRatingSubmitted(); 
                Navigator.of(context).pop();
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
