import 'package:falco_freelancer/workcards.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF007BFF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF17A2B8),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF343A40)),
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

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
        backgroundColor: const Color(0xFF0A6D92),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bem-Vindo de Volta",
                style: TextStyle(
                  color: Color(0xFF17A2B8),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Alguns Trabalhos Relacionados com você",
                style: TextStyle(
                  color: Color(0xFF17A2B8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Workscards(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Ver Mais",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard("Trabalhos Concluídos", "100%"),
                  _buildInfoCard("Conquistas", "20"),
                  _buildInfoCard("Renda", "1000R\$"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF343A40))),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF343A40))),
        ],
      ),
    );
  }
}
