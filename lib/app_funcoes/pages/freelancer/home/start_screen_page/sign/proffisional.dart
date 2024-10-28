// Página de seleção de áreas
import 'dart:async';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app_freelancer/app_funcoes/pages/constructorcards.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/start_screen_page/sign/pre-register.dart';

class Profissional extends StatefulWidget {
  final AuthService authService;
  final String? email;
  final String? password;
  Profissional(this.authService, this.email, this.password, {super.key});

  @override
  State<Profissional> createState() => _ProfissionalState();
}

class _ProfissionalState extends State<Profissional> {
  final PageController _controller = PageController();
  Timer? _timer;
  final User? user = FirebaseAuth.instance.currentUser;
  late String  userEmail = user?.email ?? ''; 

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_controller.page?.round() == 2) {
        _controller.jumpToPage(0);
      } else {
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
     appBar : AppBar(
        title: const Text(
          "Áreas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ícone de seta
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        ),
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
                    image: "image/img/hacker.png",
                    email: userEmail, 
                    authService: widget.authService,
                    area: "ti",
                    tit: "Informática",
                    destinationWidget:
                        PreRegister(authService: widget.authService, email: widget.email, password: widget.password,area: 'ti',), 
                  ),
                  Constructorcards(
                    image: "image/img/administration.png",
                    email: userEmail, 
                    authService: widget.authService,
                    area: "administration",
                    tit: "Administração",
                    destinationWidget:
                        PreRegister(authService: widget.authService, email: widget.email, password: widget.password,area: 'administration',), 
                  ),
                  Constructorcards(
                    image: "image/img/engineering.png",
                    email: userEmail, 
                    authService: widget.authService,
                    area: "edifecation",
                    tit: "Engenharia",
                    destinationWidget:
                        PreRegister(authService: widget.authService, email: widget.email, password: widget.password,area: 'edifecation',), 
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.blue.shade600,
                dotHeight: 12,
                dotWidth: 12,
                spacing: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
