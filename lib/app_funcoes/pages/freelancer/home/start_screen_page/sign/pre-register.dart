import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/checkbox.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/start_screen_page/sign/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PreRegister extends StatefulWidget {
  final AuthService authService;
  final String? email;
  final String? area;
  final String? password;
  const PreRegister({super.key, required this.authService, this.email, this.password, this.area});

  @override
  State<PreRegister> createState() => _PreRegisterState();
}

class _PreRegisterState extends State<PreRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _projectsController = TextEditingController();
  final TextEditingController _experiencesController = TextEditingController();
  final TextEditingController _averageValueController = TextEditingController();
  List<String> linguagens = [];
  List<String> classificationItems = [];
  String? dropdownValue;
  List<String> selectedLanguages = [];
  bool _isSaving = false;
  List<String> selectedItems = [];
  DateTime? _dataInicio;
  DateTime? _dataFim;
  int? datalimite;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _loadClassifications();
  }

  Future<List<String>> _optioncheck({
    required AuthService authService,
  }) async {
    if (widget.email != null) {
      List<String> esp = await authService.getHab(widget.area!, 'curses');
      return esp;
    } else {
      return [];
    }
  }

  Future<List<String>> _optioncheckDropdown({
    required AuthService authService,
  }) async {
    if (widget.email != null) {
      List<String> esp = await authService.getHab(widget.area!, 'habilidades');
      return esp;
    } else {
      return [];
    }
  }

  Future<void> _loadLanguages() async {
    List<String> loadedLanguages = await _optioncheckDropdown(
      authService: widget.authService,
    );

    setState(() {
      linguagens = loadedLanguages;
      if (linguagens.isNotEmpty) {
        dropdownValue = linguagens.first;
      }
    });
  }

  Future<void> _loadClassifications() async {
    if (widget.email != null) {
      final items = await _optioncheck(
        authService: widget.authService,
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

  // Definição do método _onSelectedItemsChanged
  void _onSelectedItemsChanged(List<String> updatedSelectedItems) {
    setState(() {
      selectedItems = updatedSelectedItems;
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

  if (selectedItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, selecione ao menos uma classificação.')),
    );
    return;
  }

  if (selectedLanguages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, selecione ao menos uma linguagem.')),
    );
    return;
  }

  setState(() {
    _isSaving = true;
  });

  try {
    await Future.delayed(const Duration(seconds: 2));
    await widget.authService.register_users(widget.email!, widget.password!, 'freelancers');
    await Future.delayed(const Duration(seconds: 2));
    // Salvar o pré-registro
    await widget.authService.savePreregister(
      _experiencesController.text,
      _nameController.text,
      selectedLanguages,
      _projectsController.text,
      widget.email,
      selectedItems,
      widget.area,
      _averageValueController.text,
    );
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSaving = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados salvos com sucesso')),
    );

    // Limpar campos e redirecionar
    _nameController.clear();
    _projectsController.clear();
    _experiencesController.clear();
    selectedLanguages.clear();
    selectedItems.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PageLogin(),
      ),
    );
  } catch (e) {
    setState(() {
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar dados: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ícone de seta
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250), // Cor do AppBar
      ),
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
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10),
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
                                            datalimite = _dataFim
                                                ?.difference(_dataInicio!)
                                                .inDays;
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
                                email: widget.email!,
                                initialSelectedItems: selectedItems, onSelectionChanged: _onSelectedItemsChanged,
                              ),
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10),
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                                if (dropdownValue != null) {
                                  _addLanguage(dropdownValue!);
                                }
                              },
                              items: linguagens.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Habilidades',
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
