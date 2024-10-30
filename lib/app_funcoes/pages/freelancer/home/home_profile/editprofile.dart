import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/checkbox.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/expandingtext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDesc = TextEditingController();
  late AuthService authService;
  late FirebaseAuth _auth;
  late User? user;
  late String userEmail;
  Map<String, dynamic>? infos;
   Map<int, bool> selectedCheckboxes = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    userEmail = user?.email ?? '';
    _loadUserInfos();
  }

  Future<void> _loadUserInfos() async {
    infos = await authService.getinfos(userEmail);
    if (infos!.isNotEmpty) {
      controllerName.text = infos!['nome'] ?? "";
      controllerDesc.text = infos!['desc'] ?? "";
    }
    setState(() {});
  }

  Future<List<String>> _optioncheck({
    required AuthService authService,
    required String userEmail,
  }) async {
    if (userEmail.isNotEmpty) {
      String? area = await authService.getArea(userEmail);
      List<String> esp = await authService.getHab(area!,'curses');
      return esp;
    } else {
      return []; // Return empty list if user is not logged in or email is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edição de Perfil",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(image: AssetImage("image/img/hacker.png")),
                ),
              ),
              const SizedBox(height: 10),
              ExpandingTextForm(
                title: "Nome",
                controller: controllerName,
                hintText: "Nome",
              ),
              ExpandingTextForm(
                title: "Descrição",
                controller: controllerDesc,
                hintText: "Descrição",
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),
              Text("Classificação", style: GoogleFonts.robotoMono(fontSize: 20)),
              const SizedBox(height: 5),
             FutureBuilder<List<String>>(
  future: _optioncheck(authService: authService, userEmail: userEmail),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      final items = snapshot.data!;
      final selectedItems = infos?['classificacao'] ?? []; // Classificações salvas
      return CheckboxWidget(
        items: items,
        authservice: authService,
        email: userEmail,
        initialSelectedItems: selectedItems,
        onSelectionChanged: (selected) {
          // Atualize a lista de classificações selecionadas
          infos?['classificacao'] = selected;
        },
      );
    } else {
      return const Text('No data available');
    }
  },
),

              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
  // Call the save function when the button is pressed
  await authService.saveProfile(
    controllerName.text,
    controllerDesc.text,
    context,
    userEmail,
    infos?['classificacao'], // Passe as classificações atualizadas
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const HomePage(),
    ),
  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Salvar Alterações",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
