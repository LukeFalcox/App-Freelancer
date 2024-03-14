// ignore_for_file: file_names

import 'package:app_freelancer/Pages/ConfigScreen/AccountScreen.dart';
import 'package:app_freelancer/Pages/Homes/HomePageChat.dart';
import 'package:app_freelancer/Pages/Works/WorkScreen.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  late PageController pageCont;

  @override
  void initState() {
    super.initState();
    pageCont = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF000000),
      body: PageView(
        controller: pageCont,
        onPageChanged: setCurrentPage,
        children: [
          Works(
            authService: AuthService(),
          ),
          const HomePageChat(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(215, 0, 0, 0),
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work, color: Color.fromARGB(255, 114, 0, 152)),
            label: 'Works',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble,
                color: Color.fromARGB(255, 156, 11, 204)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 156, 11, 204),
            ),
            label: 'Settings',
          ),
        ],
        onTap: (page) {
          pageCont.animateToPage(page,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}
