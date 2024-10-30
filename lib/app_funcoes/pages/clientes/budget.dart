import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';

class Budget extends StatefulWidget {
  final String area;
  final String userEmail;
  final AuthService authService;
  
  const Budget({
    super.key,
    required this.area,
    required this.authService,
    required this.userEmail,
  });

  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final _formKey = GlobalKey<FormState>();
  String? _areaSelecionada;
  String _valorOrcamento = '';
  DateTime? _dataInicio;
  DateTime? _dataFim;
  List<dynamic> _areas = [];

  @override
  void initState() {
    super.initState();
    _carregarAreas();  // Carregar áreas de forma assíncrona
  }

  Future<void> _carregarAreas() async {
    try {
      final areas = await widget.authService.getfilters(widget.userEmail);
      setState(() {
        _areas = areas;
      });
    } catch (e) {
      print("Erro ao carregar áreas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: const Text(
            'Orçamento',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Faça o seu Orçamento',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: 'Área do Projeto',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
    ),
  ),
  value: _areaSelecionada,
  items: _areas.map<DropdownMenuItem<String>>((area) {
    return DropdownMenuItem<String>(
      value: area.toString(),  // Certificando que 'area' seja uma string
      child: Text(area.toString()),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _areaSelecionada = value;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione uma área';
    }
    return null;
  },
),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 10),
                //   child: TextFormField(
                //     decoration: InputDecoration(
                //       labelText: 'Descrição do Projeto',
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: const BorderSide(color: Colors.blue),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                //       ),
                //     ),
                //     maxLines: 4,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Por favor, insira a descrição do projeto';
                //       }
                //       return null;
                //     },
                //     onSaved: (value) {
                //       _descricaoProjeto = value!;
                //     },
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Valor do Orçamento (R\$)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor do orçamento';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _valorOrcamento = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: _dataInicio == null
                              ? 'Data de Início'
                              : 'Início: ${DateFormat('dd/MM/yyyy').format(_dataInicio!)}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await _selecionarData(context, _dataInicio);
                          if (pickedDate != null) {
                            setState(() {
                              _dataInicio = pickedDate;
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await _selecionarData(context, _dataFim);
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
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _showFreelancersInfo(_areaSelecionada,_valorOrcamento,_dataInicio,_dataFim);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Fundo branco do botão
                    side: const BorderSide(color: Colors.blue, width: 2), // Borda azul
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'Procurar Freelancer',
                    style: TextStyle(
                      color: Colors.blue, // Texto azul igual ao das bordas
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selecionarData(BuildContext context, DateTime? dataInicial) async {
    DateTime now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: dataInicial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
  }

void _showFreelancersInfo(String? type, String valorselect, DateTime? dataInicio,  DateTime? dataFim) async {
  // Verifica se as datas de início e fim foram selecionadas
  if (dataInicio == null || dataFim == null) {
    // Mostra uma mensagem de erro se as datas não foram selecionadas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, selecione as datas de início e fim.'))
    );
    return;
  }

  // Calcula a diferença em dias entre a data de fim e a data de início
  final datalimite = dataFim.difference(dataInicio).inDays;

  // Abre o modal de freelancers
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: 400,
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _fetchFreelancers(type, valorselect, datalimite),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum freelancer encontrado.'));
            } else {
              final docs = snapshot.data!;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final name = data['nome'] ?? 'No Name';
                  final media = data['media'] ?? 0; 
                  final services = data['tipo'] ?? 'No Rate';
                  String orcamento;

                  if (media == 1) {
                    orcamento = "0R\$ ~ 200R\$";
                  } else if (media == 2) {
                    orcamento = "200R\$ ~ 500R\$";
                  } else if (media == 3) {
                    orcamento = "500R\$ ~ 1000R\$";
                  } else if (media == 4) {
                    orcamento = "1000R\$++";
                  } else {
                    orcamento = "Unknown"; 
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

Future<List<DocumentSnapshot>> _fetchFreelancers(String? type, String valorselect, int datalimite) async {
  if (type == null || type.isEmpty) {
    throw ArgumentError('O campo "type" não pode ser nulo ou vazio.');
  }

  

  await Future.delayed(const Duration(seconds: 2));

  final collectionRef = FirebaseFirestore.instance.collection('freelancers');

  // Filtra freelancers pelo tipo de classificação e compara o valor de 'datalimite'
  final snapshot = await collectionRef
      .where('classificacao', arrayContains: type) 
      // .where('datalimite', isGreaterThanOrEqualTo: datalimite) // Compara com o prazo do projeto
      // .where('valormedio', isLessThanOrEqualTo: valorMaximo) // Filtra por valor do orçamento
      .get();

  return snapshot.docs;
}
}
