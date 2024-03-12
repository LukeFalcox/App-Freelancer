// ignore_for_file: file_names

import 'package:app_freelancer/Pages/ConfigScreen/AccountScreen.dart';
import 'package:app_freelancer/Pages/Homes/HomePageChat.dart';
import 'package:app_freelancer/Pages/Works/WorkScreen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

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
          Works(),
          const HomePageChat(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 156, 11, 204)),
            label: 'Home',
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
//  bottomNavigationBar: BottomAppBar(
//           color: const Color(0xFF0C0C0C),
//           child: IconTheme(
//             data: const IconThemeData(color: Color(0xE78003C3)),
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                       hoverColor: const Color(0xFF3D3D3D),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const));
//                       },
//                       icon: const Icon(Ionicons.settings)),
//                   IconButton(
//                       hoverColor: const Color(0xFF3D3D3D),
//                       onPressed: () {},
//                       icon: const Icon(Ionicons.home)),
//                   IconButton(
//                       hoverColor: const Color(0xFF3D3D3D),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const ));
//                       },
//                       icon: const Icon(Ionicons.chatbox)),
//                   IconButton(
//                       hoverColor: const Color(0xFF3D3D3D),
//                       onPressed: () {},
//                       icon: const Icon(Ionicons.person)),
//                 ],
//               ),
//             ),
//           )),