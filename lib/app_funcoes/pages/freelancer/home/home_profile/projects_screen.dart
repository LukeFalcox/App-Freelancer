import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/ratingwidget.dart';
import 'package:flutter/material.dart'; // Importa o pacote principal do Flutter
import 'package:intl/intl.dart'; // Importa a biblioteca Intl para manipulação de datas
import 'project_detail_screen.dart'; // Importa a tela de detalhes do projeto

class ProjectsScreen extends StatefulWidget {
  final AuthService authService;
  final bool freeorcli;

  final String useremail;

  const ProjectsScreen({
    super.key,
    required this.authService,
    required this.freeorcli,
    required this.useremail,
  });

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String? area;
  late String name;
  Map<String, dynamic>? infos;
  late List<dynamic> avaliable;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArea();
  }

  void _showPaymentDialog(BuildContext context, String email) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController cardNameController = TextEditingController();
    final TextEditingController valorController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pagamento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número do Cartão',
                  ),
                ),
                TextField(
                  controller: cardNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome no Cartão',
                  ),
                ),
                TextField(
                  controller: expiryDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Data de Validade',
                    hintText: 'MM/AA',
                  ),
                ),
                TextField(
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                  ),
                ),
                TextField(
                  controller: valorController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Valor R\$',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.authService.realizarPagamento(
                    cardNameController.text,
                    cardNumberController.text,
                    expiryDateController.text,
                    valorController.text,
                    cvvController.text,
                    email);
                widget.authService.updateProjects(email, 'Pago');
                Navigator.of(context).pop();
                print(
                    'Pagamento realizado para o cartão: $cardNumberController.text');
              },
              child: const Text('Confirmar Pagamento'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchArea() async {
    area = await widget.authService.getArea(widget.useremail);
    setState(() {});
  }

  void _updateProfile(String email) {
    _loadUserInfos(
        email); // Ou qualquer outro método que atualize as informações do perfil
  }

  Future<void> _loadUserInfos(String email) async {
    try {
      infos = await widget.authService.getinfos(email);
      if (infos != null && infos!.isNotEmpty) {
        name = infos!['nome'] ?? "";
        avaliable = infos!['nota'] ?? [];
      }
    } catch (e) {
      print("Erro ao carregar informações do usuário: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Projetos"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          Expanded(
            child: FutureBuilder(
              future: widget.authService.getProjects(widget.useremail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum freelancer encontrado.'));
                } else {
                  List<dynamic> cards = snapshot.data!;
                  return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      var project = cards[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailScreen(
                                authService: widget.authService,
                                freeorcli: widget.freeorcli,
                                usercliorfree:
                                    widget.useremail == project['emailfree']!
                                        ? project['emailcli']
                                        : project['emailfree'],
                                useremail: widget.useremail,
                                project: project,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      project['titulo'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Significado do Status"),
                                            content: Text(
                                              project['status'] ==
                                                      'em andamento'
                                                  ? "O projeto está em Andamento"
                                                  : "O projeto foi Ativo",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Fechar"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (project['status'] ==
                                                'em andamento')
                                            ? Colors.orange
                                            : (project['status'] == 'Pago')
                                                ? Colors.red
                                                : Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Descrição: ${project["desc"].toLowerCase()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              ProjectWidget(project: project),
                              const SizedBox(height: 8),
                              // Botão "PAGAR" se o status for "finalizado"
                              if (project['status'] == 'finalizado' &&
                                  !widget.freeorcli)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showPaymentDialog(
                                          context, project['emailfree']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blue, // Cor de fundo do botão
                                    ),
                                    child: const Text("Pagar"),
                                  ),
                                ),
                              if (project['status'] == 'em andamento' &&
                                  project['emailfree'] == widget.useremail)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.authService.updateProjects(
                                          widget.useremail, 'finalizado');

                                      showDialog(
                                        context: context,
                                        builder: (context) => AvaliacaoWidget(
                                          email: project['emailcli'],
                                          authService: widget.authService,
                                          onRatingSubmitted: () {
                                            _updateProfile(project[
                                                'emailcli']); // Chama a função aqui
                                          },
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blue, // Cor de fundo do botão
                                    ),
                                    child: const Text("Finalizar"),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Exemplo de widget onde a data é exibida
class ProjectWidget extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Converte a string para DateTime
    DateTime dateTime = DateTime.parse(project['dtfim']);

    // Formata a data no formato desejado
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return Text(
      "Fim: $formattedDate",
      style: const TextStyle(color: Colors.grey),
    );
  }
}
