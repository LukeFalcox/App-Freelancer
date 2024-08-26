import 'dart:async';

import 'package:app_freelancer/app/pages/clientes/constructorcards.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Filterscreen extends StatefulWidget {
  const Filterscreen({super.key});

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
            "Areas",
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
              Text("Escolha a area do Projeto.",
                  style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                height: 265,
                child: PageView(
                  controller: _controller,
                  children: const [
                    Constructorcards(
                      image: "image/img/hacker.png",
                      tit: "Informatica",
                      area: 'ti',
                    ),
                    Constructorcards(
                      image: "image/img/administration.png",
                      tit: "Administração",
                      area: 'administration',
                    ),
                    Constructorcards(
                      image: "image/img/engineering.png",
                      tit: "Engenharia",
                      area: 'edifecation',
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
              )
            ],
          ),
        ));
  }
}
