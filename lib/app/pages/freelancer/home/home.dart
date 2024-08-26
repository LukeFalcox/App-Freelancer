// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_freelancer/app/pages/clientes/filterscreen.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/works/workcards.dart';

class Home extends StatefulWidget {
  final AuthService authService;
  const Home({
    super.key,
    required this.authService,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
        actions: [
  Padding(
    padding: const EdgeInsets.only(right: 16.0), // Define o espaçamento à direita
    child: ElevatedButton(
      onPressed: () {
        widget.authService.logout(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        "Logout",
        style: TextStyle(
            color: Color.fromARGB(255, 0, 128, 255),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    ),
  ),
],
          backgroundColor: const Color.fromARGB(255, 30, 81, 250),
          elevation: 0,
          toolbarHeight: 66,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Text("Bem vindo de Volta", style: TextStyle(color: Colors.blue.shade700,fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 15,
              ),
              Text("Faça seu Orçamento", style: TextStyle(color: Colors.blue.shade700,fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Filterscreen(),
                      ),
                    );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 81, 250),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Faça seu Orçamento",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text("Conheca alguns dos nossos Freelancers",style: TextStyle(color: Colors.blue.shade700,fontSize: 20,fontWeight: FontWeight.bold),),
              FreelancersCards(authService: AuthService())
            ],
          ),
        )));
  }
}

