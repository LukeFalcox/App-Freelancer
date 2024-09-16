// ignore_for_file: file_names
import 'package:app_freelancer/app/pages/freelancer/home/home.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_profile/profile.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/HomePage.dart';
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
  Widget build(BuildContext context) => Scaffold(
      // backgroundColor: const Color(0xFF000000),
      body: PageView(
    
        controller: pageCont,
        onPageChanged: setCurrentPage,
        children: [
           Home(
            authService: AuthService(),
          ),
           const ProfileScreen(),
           Homepage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0), //<-- add this
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color:  Color.fromARGB(255, 30, 81, 250),),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color:  Color.fromARGB(255, 30, 81, 250),),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble,
                color:  Color.fromARGB(255, 30, 81, 250),),
            label: 'Chat',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.work,
          //     color:  Color.fromARGB(255, 30, 81, 250),
          //   ),
          //   label: 'Settings',
          // ),
        ],
        onTap: (page) {
          pageCont.animateToPage(page,
              duration: const Duration(milliseconds: 900), curve: Curves.ease);
        },
      ),
    );
}
