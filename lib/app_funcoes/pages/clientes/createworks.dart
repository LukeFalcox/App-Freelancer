import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/expandingtext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de datas

// Tela de criação de projeto
class CriarProjetoScreen extends StatefulWidget {
  final AuthService authService;
  final String useremail;
  const CriarProjetoScreen(
      {super.key, required this.authService, required this.useremail});

  @override
  _CriarProjetoScreenState createState() => _CriarProjetoScreenState();
}

class _CriarProjetoScreenState extends State<CriarProjetoScreen> {
  final TextEditingController tituloController    = TextEditingController();
  final TextEditingController valorminController  = TextEditingController();
  final TextEditingController valormaxController  = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  String? areaSelecionada;
  String? selectedClassificacao;  // Variável específica para classificação
  String? selectedLinguagem;  // Variável específica para linguagem
  String? areadb; 
  List<String> linguagens = [];
  List<String> classificationItems = [];
  List<String> selectedLanguages = [];
  List<String> selectedClassific = [];
  bool isAreaSelected = false;
  bool isClassificacaoDropdownEnabled = false;
  bool isLinguagemDropdownEnabled = false;


  final List<String> areas = ['Tecnologia', 'Edificação', 'Administração'];

  DateTime? dataInicio;
  DateTime? dataFim;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _loadClassifications();
  }

  Future<void> _loadClassifications() async {
    final items = await _optioncheck(
      authService: widget.authService,
      userEmail: widget.useremail,
    );
    setState(() {
      classificationItems = items;
    });
  }

  Future<List<String>> _optioncheck({
    required AuthService authService,
    required String userEmail,
  }) async {
    if (userEmail.isNotEmpty) {
      
    if (areaSelecionada == 'Tecnologia') {
      areadb = 'ti';
    } else if (areaSelecionada == 'Edificação') {
      areadb = 'edifecation';
    } else if (areaSelecionada == 'Administração') {
      areadb = 'administration';
    }
      return await authService.getHab(areadb!, 'curses');
    } else {
      return [];
    }
  }

  Future<void> _selecioneData(BuildContext context, bool isInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isInicio) {
          dataInicio = picked;
        } else {
          dataFim = picked;
        }
      });
    }
  }

    Future<void> _onAreaChanged(String? newValue) async {
  setState(() {
    areaSelecionada = newValue;
    isAreaSelected = true;
    isClassificacaoDropdownEnabled = false;  // Bloqueia novamente até carregar os valores
    isLinguagemDropdownEnabled = false;
    classificationItems.clear();
    linguagens.clear();
    selectedClassificacao = null;
    selectedLinguagem = null;
  });

  if (newValue != null) {
    // Carrega as classificações e linguagens de acordo com a área selecionada
    await _loadClassifications();
    await _loadLanguages();

    // Após o carregamento, habilita os dropdowns
    setState(() {
      isClassificacaoDropdownEnabled = true;
      isLinguagemDropdownEnabled = true;
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

  void _addClassific(String classific) {
    setState(() {
      if (!selectedClassific.contains(classific)) {
        selectedClassific.add(classific);
      }
    });
  }

  void _removeLanguage(String language) {
    setState(() {
      selectedLanguages.remove(language);
    });
  }

  void _removedclassification(String classific) {
    setState(() {
      selectedClassific.remove(classific);
    });
  }

  Future<void> _loadLanguages() async {
    List<String> loadedLanguages = await _optioncheckDropdown(
      authService: widget.authService,
      userEmail: widget.useremail,
    );
    setState(() {
      linguagens = loadedLanguages;
    });
  }

  String getAreaDb(String? areaSelecionada) {
  switch (areaSelecionada) {
    case 'Tecnologia':
      return 'ti';
    case 'Edificação':
      return 'edifecation';
    case 'Administração':
      return 'administration';
    default:
      return '';
  }
}


  Future<List<String>> _optioncheckDropdown({
  required AuthService authService,
  required String userEmail,
}) async {
  String areadb = getAreaDb(areaSelecionada);
  return await authService.getHab(areadb, 'habilidades');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    centerTitle: true,
    title: const Text(
      "Criação de Projetos",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    ),
  ),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Expanded( // Adiciona o Expanded para ajustar o tamanho
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpandingTextForm(
                  title: "Titulo",
                  controller: tituloController,
                  hintText: "Titulo",
                ),
                const SizedBox(height: 16),
                ExpandingTextForm(
                  title: "Descrição",
                  controller: descricaoController,
                  hintText: "Descrição",
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: areaSelecionada,
                  items: areas.map((String area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                  onChanged: _onAreaChanged,
                  decoration: InputDecoration(
                    labelText: 'Área',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isAreaSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedClassificacao,
                  items: classificationItems.map((String classificacao) {
                    return DropdownMenuItem<String>(
                      value: classificacao,
                      child: Text(classificacao),
                    );
                  }).toList(),
                  onChanged: isClassificacaoDropdownEnabled
                      ? (String? newValue) {
                          setState(() {
                            selectedClassificacao = newValue;
                            if (newValue != null) {
                              _addClassific(newValue);
                            }
                          });
                        }
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Classificação',
                    border: OutlineInputBorder(),
                  ),
                  disabledHint: const Text('Selecione uma área primeiro'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLinguagem,
                  items: linguagens.map((String linguagem) {
                    return DropdownMenuItem<String>(
                      value: linguagem,
                      child: Text(linguagem),
                    );
                  }).toList(),
                  onChanged: isLinguagemDropdownEnabled
                      ? (String? newValue) {
                          setState(() {
                            selectedLinguagem = newValue;
                            if (newValue != null) {
                              _addLanguage(newValue);
                            }
                          });
                        }
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Linguagens',
                    border: OutlineInputBorder(),
                  ),
                  disabledHint: const Text('Selecione uma área primeiro'),
                ),
                const SizedBox(height: 16),
                ExpandingTextForm(
                  title: "Valor Min",
                  controller: valorminController,
                  hintText: "Valor Min",
                ),
                const SizedBox(height: 16),
                ExpandingTextForm(
                  title: "Valor Max",
                  controller: valormaxController,
                  hintText: "Valor Max",
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _selecioneData(context, false),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: dataFim == null
                            ? 'Data de Fim'
                            : DateFormat('dd/MM/yyyy').format(dataFim!),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 8.0,
                  children: selectedLanguages.map((language) {
                    return Chip(
                      label: Text(language),
                      onDeleted: () {
                        setState(() {
                          _removeLanguage(language);
                        });
                      },
                    );
                  }).toList(),
                ),
                Wrap(
                  spacing: 8.0,
                  children: selectedClassific.map((classific) {
                    return Chip(
                      label: Text(classific),
                      onDeleted: () {
                        setState(() {
                          _removedclassification(classific);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (areaSelecionada != null &&
                        tituloController.text.isNotEmpty) {
                      await widget.authService.saveProjects(
                        areadb!,
                        selectedClassific,
                        selectedLanguages,
                        descricaoController.text,
                        widget.useremail,
                        tituloController.text,
                        valormaxController.text,
                        valorminController.text,
                        'em andamento',
                        dataFim,
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Criar Projeto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);
  }
}
