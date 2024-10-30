import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/profile.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/HomePage.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int currentPage = 0;
  late PageController pageCont;
  late Future<Map<String, dynamic>?> userinfoFuture; // Declare a future para carregar os dados do usuário
  late String currentUserEmail;
  bool freeorcli = false;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    pageCont = PageController(initialPage: currentPage);
    userinfoFuture = _initializeUserInfo(); // Inicia a função que carrega os dados
  }

  Future<Map<String, dynamic>?> _initializeUserInfo() async {
    currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    return await authService.verificationTypeUser(currentUserEmail);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userinfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto os dados estão sendo carregados
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            // Em caso de erro ou dados nulos
            return const Center(child: Text('Erro ao carregar informações.'));
          }

          // Dados carregados com sucesso
          final userinfo = snapshot.data!;
          freeorcli = userinfo['isFreelancer'];

          return PageView(
            controller: pageCont,
            onPageChanged: setCurrentPage,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Home(authService: authService, freeorcli: freeorcli),
              ProfileScreen(freeorcli: freeorcli, authService: authService,),
              HomepageChat(freeorcli: freeorcli),
              // Paymentscreen()
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 30, 81, 250)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Color.fromARGB(255, 30, 81, 250)),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble,
                color: Color.fromARGB(255, 30, 81, 250)),
            label: 'Chat',
          ),
        ],
        onTap: (page) {
          pageCont.animateToPage(
            page,
            duration: const Duration(milliseconds: 900),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
