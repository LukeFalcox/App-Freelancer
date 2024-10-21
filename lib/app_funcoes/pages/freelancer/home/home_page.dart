import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/profile.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/HomePage.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/payments/paymentscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int currentPage = 0;
  late PageController pageCont;
  Map<String, dynamic>? userinfo; // Define como opcional (pode ser nulo)
  late String currentUserEmail;
  bool freeorcli = false;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    pageCont = PageController(initialPage: currentPage);
    _initializeUserInfo(); // Chama a função assíncrona para carregar os dados
  }

  Future<void> _initializeUserInfo() async {
    currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    userinfo = await authService.verificationTypeUser(currentUserEmail);
    freeorcli = userinfo!['isFreelancer'];
    setState(() {}); // Atualiza a UI depois de obter os dados
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se os dados do userinfo foram carregados
    if (userinfo == null) {
      return const Center(
        child: CircularProgressIndicator(), // Exibe um indicador de carregamento enquanto userinfo está nulo
      );
    }

    return Scaffold(
      body: PopScope(
        canPop: false,
        child: PageView(
          controller: pageCont,
          onPageChanged: setCurrentPage,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Home(authService: authService, freeorcli:freeorcli),
            ProfileScreen(freeorcli: freeorcli),
            HomepageChat(freeorcli: freeorcli),
            Paymentscreen()
          ],
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble,
                color: Color.fromARGB(255, 30, 81, 250)),
            label: 'Pagamento(Teste)',
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
