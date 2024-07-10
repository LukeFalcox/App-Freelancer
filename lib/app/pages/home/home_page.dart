// ignore_for_file: file_names

import 'package:app_freelancer/app/pages/home/home_config/account_page.dart';
import 'package:app_freelancer/app/pages/home/home_chat/home_chat_page.dart';
import 'package:app_freelancer/app/pages/home/home_profile/profile.dart';
import 'package:app_freelancer/app/pages/home/works/work_page.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Container(
      decoration: const BoxDecoration(
  image: DecorationImage(
    image: AssetImage("images/back.jpg"),
    fit: BoxFit.cover,
  ),
),
      child: Scaffold(
        // backgroundColor: const Color(0xFF000000),
        body: PageView(

          controller: pageCont,
          onPageChanged: setCurrentPage,
          children: [
             const Profile(),
            const HomePageChat(),
           Works(
              authService: AuthService(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(215, 0, 0, 0),
          currentIndex: currentPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people, color: Color.fromARGB(255, 114, 0, 152)),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble,
                  color: Color.fromARGB(255, 156, 11, 204)),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.work,
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
      ),
    );
  }
}
