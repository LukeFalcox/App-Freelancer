import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/ChatPage.dart';
import 'package:flutter/material.dart';

// Tela de detalhes do projeto
class ProjectDetailScreen extends StatefulWidget {
  final AuthService authService;
  final String usercliorfree;
  final Map<String, dynamic> project;
  final bool freeorcli;
  final String useremail;

  const ProjectDetailScreen({super.key, required this.authService, required this.useremail, required this.freeorcli, required this.usercliorfree, required this.project}); // Construtor que inicializa o projeto
//required this.project
  @override
  // ignore: library_private_types_in_public_api
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState(); // Cria o estado da tela
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late String _status; // Armazena o status atual do projeto

  @override
  void initState() {
    super.initState();
    // _status = widget.project.status; // Inicializa o status com o status do projeto
  }

  // Função para alterar o status do projeto
  void _toggleStatus() {
    setState(() {
      _status = (_status == 'Ativo') ? 'Inativo' : 'Ativo'; // Alterna entre Ativo e Inativo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project['titulo']), // Título da tela é o título do projeto
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento ao redor do conteúdo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo à esquerda
          children: [
            Container(
              padding: const EdgeInsets.all(16), // Espaçamento interno do card
              decoration: BoxDecoration(
                color: Colors.white, // Cor de fundo do card
                borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Sombra leve do card
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3), // Deslocamento da sombra
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda
                children: [
                  Text(
                    widget.project['titulo'], // Título do projeto
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Estilo do título
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Autor: ${widget.project['emailcli']}",  // Exibe o autor do projeto
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16), // Espaçamento entre o título e a descrição
                  Text(
                    widget.project['desc'], // Descrição do projeto
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700], // Cor da descrição
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Fim: ${widget.project['fim']}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                    
                  const SizedBox(height: 16), // Espaçamento antes do botão de chat
                  ElevatedButton(
                    onPressed: () async{
                      String? chatroomid = await widget.authService.getChatRoomId(widget.useremail, widget.usercliorfree);
                      String? receiverUserID = await widget.authService.receiverUserID(widget.useremail, widget.usercliorfree,widget.freeorcli, chatroomid!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPageNew(authService: widget.authService,chatRoomId: chatroomid, email:widget.usercliorfree ,receiverUserID: receiverUserID! ,), // Crie a tela de chat como um widget separado
                        ),
                      );
                    },
                    child: const Text("Acessar Chat"), // Texto do botão de chat
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
