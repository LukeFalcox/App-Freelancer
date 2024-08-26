import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Budget extends StatefulWidget {
  final String area;
  const Budget({super.key, required this.area});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  int _selectedOption = 1; // Armazena a opção selecionada
  DateTime? _selectedDate;
  String? _selectedValue;
  List<String> _options = []; // Lista de opções do dropdown

  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }

  Future<void> _fetchOptions() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('filters').doc('VPyiRaZZB8IyxoxOpotH').get();
      
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        
        if (data.containsKey('curses') && data['curses'] is Map) {
          final curses = data['curses'] as Map<String, dynamic>;
          
          if (curses.containsKey(widget.area) && curses[widget.area] is List) {
            final List<dynamic> optionsList = curses[widget.area] as List<dynamic>;
            
            final List<String> options = optionsList.map((option) => option.toString()).toList();
            
            setState(() {
              _options = options;
            });
          } else {
            print('Campo ${widget.area} não encontrado ou não é uma lista');
          }
        } else {
          print('Campo curses não encontrado ou não é um mapa');
        }
      } else {
        print('Documento não encontrado');
      }
    } catch (e) {
      print('Error fetching options: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

void _showFreelancersInfo(String? type, int valorselect) async {
  // Mostra um modal de carregamento enquanto busca os dados
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: 400,
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _fetchFreelancers(type, valorselect),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Exibe um indicador de carregamento enquanto a requisição está em andamento
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Exibe uma mensagem de erro caso ocorra algum problema
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Exibe uma mensagem caso nenhum freelancer seja encontrado
              return const Center(child: Text('Nenhum freelancer encontrado.'));
            } else {
              // Constrói a lista de freelancers com base nos dados obtidos
              final docs = snapshot.data!;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final name = data['nome'] ?? 'No Name';
                  final media = data['media'] ?? 0; // Use 0 como valor padrão para 'media'
                  final services = data['tipo'] ?? 'No Rate';
                  String orcamento;

                  // Define orcamento com base em 'media'
                  if (media == 1) {
                    orcamento = "0R\$ ~ 200R\$";
                  } else if (media == 2) {
                    orcamento = "200R\$ ~ 500R\$";
                  } else if (media == 3) {
                    orcamento = "500R\$ ~ 1000R\$";
                  } else if (media == 4) {
                    orcamento = "1000R\$++";
                  } else {
                    orcamento = "Unknown"; // Valor padrão caso 'media' não corresponda a nenhum dos casos
                  }
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: $name', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Expertise: $orcamento'),
                        Text('Services: $services'),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      );
    },
  );
}

Future<List<DocumentSnapshot>> _fetchFreelancers(String? type, int valorselect) async {
  // Verifica se o 'type' é válido
  if (type == null || type.isEmpty) {
    throw ArgumentError('O campo "type" não pode ser nulo ou vazio.');
  }
  
  // Simula uma demora no carregamento
  await Future.delayed(const Duration(seconds: 2));
  
  // Obtendo uma referência à coleção 'freelancers'
  final collectionRef = FirebaseFirestore.instance.collection('freelancers');

  // Filtrando documentos com base no valor de 'type' e 'valorselect'
  final snapshot = await collectionRef
      .where('tipo', isEqualTo: type) // Filtra por 'tipo'
      .where('media', isEqualTo: valorselect) // Filtra por 'media'
      .get();

  return snapshot.docs;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orçamento",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Faça aqui o seu Orçamento",
                style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "&",
                style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Procure pelo Freelancer ideal",
                style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 500,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text("Tipo de Projeto"),
                        DropdownButton<String>(
                          value: _selectedValue,
                          hint: const Text('Selecione uma opção'),
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue = newValue;
                            });
                          },
                          items: _options.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Text("Valor Médio"),
                        Wrap(
                          spacing: 15,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildOptionButton("0R\$ ~ 200R\$", 1),
                            _buildOptionButton("200R\$ ~ 500R\$", 2),
                            _buildOptionButton("500R\$ ~ 1000R\$", 3),
                            _buildOptionButton("1000R\$++", 4),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Data de Término"),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Selecionar Data'),
                        ),
                        if (_selectedDate != null)
                          Text(
                            "Data Selecionada: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: (){
                            _showFreelancersInfo(_selectedValue,_selectedOption);
                          },
                          child: const Text('Mostrar Freelancers'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, int value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedOption == value
            ? Colors.blue.shade700
            : const Color.fromARGB(255, 255, 255, 255),
      ),
      onPressed: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black)),
    );
  }
}
