// ignore_for_file: file_names

import 'package:app_freelancer/Pages/Homes/HomePageChat.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF0C0C0C),
          child: IconTheme(
            data: const IconThemeData(color: Color(0xE78003C3)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      hoverColor: const Color(0xFF3D3D3D),
                      onPressed: () {},
                      icon: const Icon(Ionicons.settings)),
                  IconButton(
                      hoverColor: const Color(0xFF3D3D3D),
                      onPressed: () {},
                      icon: const Icon(Ionicons.home)),
                  IconButton(
                      hoverColor: const Color(0xFF3D3D3D),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePageChat()));
                      },
                      icon: const Icon(Ionicons.chatbox)),
                  IconButton(
                      hoverColor: const Color(0xFF3D3D3D),
                      onPressed: () {},
                      icon: const Icon(Ionicons.person)),
                ],
              ),
            ),
          )),
    );
  }
}
