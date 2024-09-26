import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_profile/checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreRegister extends StatefulWidget {
  final AuthService authService;
  const PreRegister({super.key, required this.authService});

  @override
  State<PreRegister> createState() => _PreRegisterState();
}

class _PreRegisterState extends State<PreRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _projectsController = TextEditingController();
  final TextEditingController _experiencesController = TextEditingController();
  late FirebaseAuth _auth;
  late User? user;
  late String userEmail = "";
  List<String> linguagens = []; // Inicialização da lista de linguagens
  String? dropdownValue;
  List<String> selectedLanguages = [];
  bool _isSaving = false; // Para indicar se o formulário está sendo salvo

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _loadLanguages(); // Carregar as linguagens na inicialização
  }

  Future<List<String>> _optioncheck({
    required AuthService authService,
    required String userEmail,
  }) async {
    if (userEmail.isNotEmpty) {
      String? area = await authService.getArea(userEmail);
      List<String> esp = await authService.getHab(area!, 'curses');
      return esp;
    } else {
      return []; // Retornar lista vazia se o usuário não estiver logado ou email indisponível
    }
  }


  Future<List<String>> _optioncheckDropdown({
    required AuthService authService,
    required String userEmail,
  }) async {
    if (userEmail.isNotEmpty) {
      String? area = await authService.getArea(userEmail);
      List<String> esp = await authService.getHab(area!, 'habilidades');
      return esp;
    } else {
      return []; // Retornar lista vazia se o usuário não estiver logado ou email indisponível
    }
  }

  // Carregar as linguagens
  Future<void> _loadLanguages() async {
    user = _auth.currentUser;
    if (user != null) {
      userEmail = user?.email ?? '';
    }

    List<String> loadedLanguages = await _optioncheckDropdown(
      authService: widget.authService,
      userEmail: userEmail,
    );

    setState(() {
      linguagens = loadedLanguages;
      if (linguagens.isNotEmpty) {
        dropdownValue = linguagens.first; // Define o valor inicial
      }
    });
  }

  void _addLanguage(String language) {
    setState(() {
      if (!selectedLanguages.contains(language)) {
        selectedLanguages.add(language);
      }
    });
  }

  void _removeLanguage(String language) {
    setState(() {
      selectedLanguages.remove(language);
    });
  }

  bool _isFormValid() {
    if (_nameController.text.isEmpty ||
        _projectsController.text.isEmpty ||
        _experiencesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return false;
    }
    if (selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione ao menos uma linguagem')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveForm() async {
    if (!_isFormValid()) return;

    setState(() {
      _isSaving = true;
    }); // Aqui irá salvar as informações

    await Future.delayed(const Duration(seconds: 2));

    await widget.authService.savePreregister(
      _experiencesController.text,
      _nameController.text,
      selectedLanguages,
      _projectsController.text,
      userEmail,
    );

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados salvos com sucesso')),
    );

    _nameController.clear();
    _projectsController.clear();
    _experiencesController.clear();
    selectedLanguages.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 30, 81, 250),
                Color.fromARGB(255, 15, 70, 253),
                Color.fromARGB(255, 0, 38, 255),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 90),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Fale sobre você",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            _buildTextField(
                              controller: _nameController,
                              hint: "Nome completo",
                            ),
                            _buildTextField(
                              controller: _projectsController,
                              hint: "Projetos realizados",
                            ),
                            _buildTextField(
                              controller: _experiencesController,
                              hint: "Descrição",
                            ),
                            if (linguagens.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Classificação",
                                      style: GoogleFonts.robotoMono(fontSize: 20),
                                    ),
                                    const SizedBox(height: 5),
                                    FutureBuilder<List<String>>(
                                      future: _optioncheck(
                                        authService: widget.authService,
                                        userEmail: userEmail,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else if (snapshot.hasData) {
                                          final items = snapshot.data!;
                                          return CheckboxWidget(
                                            items: items,
                                            authservice: widget.authService,
                                            email: userEmail,
                                          );
                                        } else {
                                          return const Text('No data available');
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Linguagens: ',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 10),
                                        DropdownButton<String>(
                                          value: dropdownValue,
                                          icon: const Icon(Icons.arrow_downward),
                                          elevation: 16,
                                          style: const TextStyle(
                                            color: Colors.deepPurple,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              dropdownValue = value!;
                                            });
                                            _addLanguage(dropdownValue!);
                                          },
                                          items: linguagens.map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 15),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: selectedLanguages.map((language) {
                                        return Chip(
                                          label: Text(language),
                                          onDeleted: () {
                                            _removeLanguage(language);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _isSaving
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _saveForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 0, 35, 230),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 50),
                                elevation: 5,
                              ),
                              child: const Text(
                                "Salvar",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
