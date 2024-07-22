// ignore_for_file: file_names
import 'package:falco_freelancer/home.dart';
import 'package:falco_freelancer/workscreate.dart';
import 'package:flutter/material.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
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
        children: const [
          Home(),
          WorksCreate(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Color.fromARGB(255, 18, 161, 213),
            ),
            label: 'Works',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble,
              color: Color.fromARGB(255, 18, 161, 213),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 18, 161, 213),
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
