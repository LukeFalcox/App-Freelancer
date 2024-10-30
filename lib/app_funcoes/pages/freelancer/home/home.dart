// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/ChatPage.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/profile.dart';

class Home extends StatefulWidget {
  final AuthService authService;
  final bool freeorcli;

  const Home({
    super.key,
    required this.authService,
    required this.freeorcli,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseAuth _auth;
  User? user;
  late String userEmail;
  String? valueFilter;
  String selectedArea = 'Tecnologia'; // Valor padrão do dropdown
  List<Map<String, dynamic>> userInfoList = []; // Lista de projetos
  List<String> freelancerProjects = []; // Lista de projetos já atribuídos ao freelancer
  List<String> freelancerContacts = []; // Lista de contatos de freelancers
  final List<String> areas = ['Tecnologia', 'Edificação', 'Administração'];

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    userEmail = user?.email ?? '';
    valueFilter = "All";

    // Carregar os projetos e a lista de projetos do freelancer
    loadProjectsOrFreelancers();
    loadFreelancerProjects(); // Carregar a lista de projetos atribuídos ao freelancer
    loadFreelancersContacts();
  }

  Future<void> loadProjectsOrFreelancers() async {
    final data = await widget.authService.getprojectsorfreelancers(valueFilter ?? "All", userEmail, selectedArea);
    setState(() {
      userInfoList = data ?? [];
    });
  }

  

  // Carregar os projetos atribuídos ao freelancer diretamente do Firestore
  Future<void> loadFreelancerProjects() async {
    final freelancerProjectsSnapshot = await FirebaseFirestore.instance
        .collection('freelancers')
        .where('email', isEqualTo: userEmail)
        .get();

    if (freelancerProjectsSnapshot.docs.isNotEmpty) {
      setState(() {
        freelancerProjects = List<String>.from(freelancerProjectsSnapshot.docs.first.data()['projects']);
      });
    }
  }

 Future<void> loadFreelancersContacts() async {
  try {
    List<String> freelancerContactsLocal = []; 
    final chatCollection = await FirebaseFirestore.instance.collection('chat').get();

    if (chatCollection.docs.isNotEmpty) {
      for (var chatDoc in chatCollection.docs) {
        final usersCollection = await chatDoc.reference.collection('users').get();

        if (usersCollection.docs.isNotEmpty) {
          for (var userDoc in usersCollection.docs) {
            if (userDoc.data()['cliente'] == userEmail) {
              var freelancerData = userDoc.data()['freelancer'];
              
              // Verifique se freelancerData é uma String
              if (freelancerData is String) {
                // Adiciona o e-mail do freelancer à lista
                freelancerContactsLocal.add(freelancerData);
              } else {
                print('O campo "freelancer" não é uma string ou está ausente: $freelancerData');
              }
            }
          }
        }
      }
    }

    setState(() {
      freelancerContacts = freelancerContactsLocal; // Armazena os contatos de freelancers
    });
  } catch (e) {
    print('Erro ao carregar contatos de freelancers: $e');
  }
}


  void removeCard(int index) {
    setState(() {
      userInfoList.removeAt(index); // Remove o card da lista
    });
  }

  bool isProjectAlreadyAssigned(String projectId) {
    return freelancerProjects.contains(projectId); // Verifica se o projeto já foi atribuído
  }

  bool isFreelancerAlreadyAssigned(String contact) {
    return freelancerContacts.contains(contact); // Verifica se o projeto já foi atribuído
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bem vindo, temos novidades para você",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: const Row(
                  children: [
                    Icon(Ionicons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Pesquisar por trabalhos",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Categorias",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        valueFilter = 'All';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20), // Adiciona padding
                      decoration: BoxDecoration(
                        color: valueFilter == 'All'
                            ? const Color(0xff568A9F)
                            : Colors.transparent, // Muda a cor de fundo
                        borderRadius:
                            BorderRadius.circular(30), // Bordas arredondadas
                        border: Border.all(
                          color: const Color(0xff568A9F), // Cor da borda
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Ver Tudo',
                        style: TextStyle(
                          color: valueFilter == 'All'
                              ? Colors.white
                              : const Color(0xff568A9F), // Muda a cor do texto
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20,),

                   DropdownButton<String>(
                value: selectedArea,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedArea = newValue!;
                    loadProjectsOrFreelancers(); // Recarrega os projetos com o novo filtro
                  });
                },
                items: areas.map<DropdownMenuItem<String>>((String area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
              ),

                  
                ],
              ),
              const SizedBox(height: 25),
              FutureBuilder<List<dynamic>>(
                future: widget.authService.getfileterhome(userEmail,selectedArea),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available');
                  } else {
                    List<dynamic> categories = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          categories.length,
                          (index) => Container(
                            margin:
                                const EdgeInsets.only(right: 20, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  valueFilter = categories[index];
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    valueFilter == categories[index]
                                        ? const Color(0xff568A9F)
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  color: valueFilter == categories[index]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Para você",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("Ver mais")),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: FutureBuilder<List<Map<String, dynamic>>?>(
                  future: widget.authService.getprojectsorfreelancers(
                      valueFilter!, userEmail,selectedArea), // Usa o selectedArea como filtro
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Erro ao carregar informações.'));
                    }
                    if (snapshot.hasData) {
                      final List<Map<String, dynamic>>? userInfoList = snapshot.data;
                      if (userInfoList == null || userInfoList.isEmpty) {
                        return const Center(child: Text('Nenhum projeto encontrado.'));
                      }

                      return SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: userInfoList.length,
                          itemBuilder: (context, index) {
                            final userInfo = userInfoList[index];
                            final projectId = userInfo['id'];
                            final emailCli = userInfo['emailcli'];

                            // Verificar se o projeto já foi atribuído ao freelancer
                            if (widget.freeorcli) {
                              if (isProjectAlreadyAssigned(projectId)) {
                                return Container(); // Retorna um Container vazio se já estiver atribuído
                              }
                            } else {
                              if (isFreelancerAlreadyAssigned(userInfo['email'])) {
                                return Container(); 
                              }
                            }

                            if (widget.freeorcli) {
                              return FutureBuilder<Map<String, dynamic>>(
                                future: widget.authService.getClientInfo(emailCli),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return const Center(child: Text('Erro ao carregar informações.'));
                                  }
                                  if (snapshot.hasData && snapshot.data != null) {
                                    final clientData = snapshot.data!;
                                    final name = clientData['name'] ?? 'Nome Desconhecido';
                                    final nota = clientData['nota'] ?? ["0"];
                                    return UserCard(
                                      name: name,
                                      rating: nota,
                                      classification: userInfo['classificao'] ?? [],
                                      authService: widget.authService,
                                      userinfo: userInfo,
                                      useremail: userEmail,
                                      freeorcli: widget.freeorcli,
                                    );
                                  }
                                  return const Text('Informações não disponíveis.');
                                },
                              );
                            } else {
                              return UserCard(
                                name: userInfo['nome'] ?? 'Nome Desconhecido',
                                rating: userInfo['nota'] ?? ["0"],
                                classification: userInfo['classificacao'] ?? [],
                                userinfo: userInfo,
                                useremail: userEmail,
                                authService: widget.authService,
                                freeorcli: widget.freeorcli,
                              );
                            }
                          },
                        ),
                      );
                    }
                    return const Center(child: Text('Nenhum projeto encontrado.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final String name;
  final String useremail;
  final List<dynamic> rating;
  final List classification;
  final Map<String, dynamic> userinfo;
  final AuthService authService;
  final bool freeorcli;

  const UserCard({
    super.key,
    required this.name,
    required this.useremail,
    required this.rating,
    required this.classification,
    required this.userinfo,
    required this.authService,
    required this.freeorcli,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: widget.freeorcli ? _buildClientProjectCard() : _buildFreelancerCard(context),
    );
  }

Widget _buildFreelancerCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundImage: AssetImage('images/img/user.png'),
                ),
                const SizedBox(width: 5),
                 Expanded(
              child: Text(
                widget.name.isNotEmpty ? widget.name : 'Nome Desconhecido',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
              ],
            ),
           
            const SizedBox(height: 5),
            StarBar(rating: widget.rating, size: 12),
            const SizedBox(height: 8),
            const Text(
              "Especialidades",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 4.0,
              runSpacing: 2.0,
              children: List.generate(
                widget.classification.length,
                (index) => Text("- ${widget.classification[index]}", style: const TextStyle(fontSize: 10),),
              ),
            ),
          ],
        ),
        
        Positioned(
          bottom: 8, // Ajuste a distância do fundo conforme necessário
          right: 8,  // Ajuste a distância da direita conforme necessário
          child: ElevatedButton(
            onPressed: () async{
              String? receiverUserID ;
            String? chatvery = await widget.authService.getChatRoomId(widget.useremail, widget.userinfo['email']);
            if (chatvery == null) {
              String chatRoomId = await widget.authService.createChatrooms(widget.userinfo['email'],widget.useremail);
              receiverUserID = await widget.authService.receiverUserID(widget.useremail, widget.userinfo['email'],widget.freeorcli,chatRoomId);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPageNew(receiverUserID: receiverUserID!, chatRoomId: chatRoomId, authService: widget.authService, email: widget.userinfo['email']),));
            }
            receiverUserID = await widget.authService.receiverUserID(widget.useremail, widget.userinfo['email'],widget.freeorcli,chatvery!);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPageNew(receiverUserID: receiverUserID!, chatRoomId: chatvery, authService: widget.authService, email: widget.userinfo['email']),));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 30, 81, 250),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              minimumSize: const Size(30, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '+',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildClientProjectCard() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundImage: AssetImage('assets/default_avatar.png'),
                ),
                const SizedBox(width: 5),
                 Expanded(
              child: Text(
                widget.name.isNotEmpty ? widget.name : 'Nome Desconhecido',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
              ],
            ),
           
            const SizedBox(height: 5),
            StarBar(rating: widget.rating, size: 12),
              Text(
                "Titulo: ${widget.userinfo['titulo']}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                "Desc: ${widget.userinfo['desc']}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 3,),
              const Text(
                    'Valores',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10),
                  ),
              const SizedBox(height: 3,),
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.red,),
                  const SizedBox(width: 2,),
                  Text(
                    widget.userinfo['valmin'] ?? '0',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(width: 10,),
                  const Icon(Icons.attach_money, color: Colors.green,),
                  const SizedBox(width: 2,),
                  Text(
                    widget.userinfo['valmax'] ?? '0',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ElevatedButton(
             onPressed: () async {
              await widget.authService.setprojectorfreelancers(widget.userinfo['id'], widget.useremail);
              String? receiverUserID ;
            String? chatvery = await widget.authService.getChatRoomId(widget.useremail, widget.userinfo['emailcli']);
            if (chatvery == null) {
              String chatRoomId = await widget.authService.createChatrooms(widget.useremail, widget.userinfo['emailcli']);
              receiverUserID = await widget.authService.receiverUserID(widget.useremail, widget.userinfo['emailcli'],widget.freeorcli,chatRoomId);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPageNew(receiverUserID: receiverUserID!, chatRoomId: chatRoomId, authService: widget.authService, email: widget.userinfo['emailcli']),));
            }
            receiverUserID = await widget.authService.receiverUserID(widget.useremail, widget.userinfo['emailcli'],widget.freeorcli,chatvery!);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPageNew(receiverUserID: receiverUserID!, chatRoomId: chatvery, authService: widget.authService, email: widget.userinfo['emailcli']),));
              
              setState(() {
                // Sem lógica adicional, apenas para garantir que a tela inteira seja reconstruída.
              });
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 81, 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                minimumSize: const Size(30, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "+",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
