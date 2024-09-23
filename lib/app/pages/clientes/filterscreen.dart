import 'dart:async';
import 'package:app_freelancer/app/pages/clientes/budget.dart';
import 'package:app_freelancer/app/pages/clientes/constructorcards.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart'; // Importando AuthService

class Filterscreen extends StatefulWidget {
  final AuthService authService;
  final String userEmail; 

  const Filterscreen({super.key, required this.authService, required this.userEmail});

  @override
  State<Filterscreen> createState() => _FilterscreenState();
}

class _FilterscreenState extends State<Filterscreen> {
  final _controller = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Inicia o timer para mudar a página automaticamente
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_controller.page?.round() == 2) {
        // Se estiver na última página, volte para a primeira
        _controller.jumpToPage(0);
      } else {
        // Avance para a próxima página
        _controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela o timer quando o widget é descartado
    _controller.dispose(); // Descarte o controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Áreas",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 30, 81, 250),
          elevation: 0,
          toolbarHeight: 66,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Escolha a área do Projeto.",
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 265,
                child: PageView(
                  controller: _controller,
                  children: [
                    Constructorcards(
                      image: "image/img/administration.png",
                      email: widget.userEmail, // Passando o email do usuário
                      authService: widget.authService, // Passando o authService
                      area: "administration",
                      tit: "Administração",
                      destinationWidget: Budget(area: 'administration'), 
                    ),
                    Constructorcards(
                      image: "image/img/administration.png",
                      email: widget.userEmail, // Passando o email do usuário
                      authService: widget.authService, // Passando o authService
                      area: "ti",
                      tit: "Tecnologia da Informação",
                      destinationWidget: Budget(area: 'ti'), 
                    ),
                    Constructorcards(
                      image: "image/img/engineering.png",
                      email: widget.userEmail, // Passando o email do usuário
                      authService: widget.authService, // Passando o authService
                      area: "engineering",
                      tit: "Engenharia",
                      destinationWidget: Budget(area: 'engineering'), 
                    ),
                  ],
                ),
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: JumpingDotEffect(
                  activeDotColor: Colors.blue.shade600,
                  dotColor: Colors.blue.shade600,
                  dotHeight: 15,
                  dotWidth: 15,
                  spacing: 16,
                  verticalOffset: 40,
                ),
              ),
            ],
          ),
        ));
  }
}
