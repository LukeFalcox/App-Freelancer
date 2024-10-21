import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _averageValueController = TextEditingController();
  late FirebaseAuth _auth;
  late User? user;
  late String userEmail = "";
  List<String> linguagens = [];
  List<String> classificationItems = [];
  String? dropdownValue;
  List<String> selectedLanguages = [];
  bool _isSaving = false;
  List<String> selectedItems = [];
  DateTime? _dataInicio;
  DateTime? _dataFim;
  var datalimite;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _loadLanguages();
    _loadClassifications();
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
      return [];
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
      return [];
    }
  }

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
        dropdownValue = linguagens.first;
      }
    });
  }

  Future<void> _loadClassifications() async {
    if (userEmail.isNotEmpty) {
      final items = await _optioncheck(
        authService: widget.authService,
        userEmail: userEmail,
      );
      setState(() {
        classificationItems = items;
      });
    }
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
        const SnackBar(
            content: Text('Por favor, selecione ao menos uma linguagem')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveForm() async {
    if (!_isFormValid()) return;

    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    await widget.authService.savePreregister(
        _experiencesController.text,
        _nameController.text,
        selectedLanguages,
        _projectsController.text,
        userEmail,
        datalimite,
        _averageValueController.text);

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
                              hint: "Descrição sobre você",
                            ),
                            _buildTextField(
                              controller: _averageValueController,
                              hint: "Valor médio por projeto",
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: _dataInicio == null
                                            ? 'Data de Início'
                                            : 'Início: ${DateFormat('dd/MM/yyyy').format(_dataInicio!)}',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await _selecionarData(
                                                context, _dataInicio);
                                        if (pickedDate != null) {
                                          setState(() {
                                            _dataInicio = pickedDate;
                                            datalimite = _dataFim?.difference(_dataInicio!).inDays;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: _dataFim == null
                                            ? 'Data de Fim'
                                            : 'Fim: ${DateFormat('dd/MM/yyyy').format(_dataFim!)}',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await _selecionarData(
                                                context, _dataFim);
                                        if (pickedDate != null) {
                                          setState(() {
                                            _dataFim = pickedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Selecione sua área de atuação:',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CheckboxWidget(
                                items: classificationItems,
                                authservice: widget.authService,
                                email: userEmail,
                                initialSelectedItems: selectedItems,
                              ),
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10),
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
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
                              decoration: InputDecoration(
                                labelText: 'Linguagens conhecidas',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              children: selectedLanguages
                                  .map((language) => Chip(
                                        label: Text(language),
                                        onDeleted: () {
                                          _removeLanguage(language);
                                        },
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => _saveForm(),
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue[900],
                          ),
                          child: Center(
                            child: _isSaving
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Salvar",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Future<DateTime?> _selecionarData(
      BuildContext context, DateTime? initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
}