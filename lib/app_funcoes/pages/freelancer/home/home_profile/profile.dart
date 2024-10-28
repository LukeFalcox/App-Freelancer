// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:app_freelancer/app_funcoes/pages/clientes/createworks.dart';
import 'package:app_freelancer/app_funcoes/pages/clientes/filterscreen.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/projects_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/editprofile.dart';
import 'ratingwidget.dart';

class ProfileScreen extends StatefulWidget {
  final bool freeorcli;
  const ProfileScreen({super.key, required this.freeorcli});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  Map<String, dynamic>? infos;
  late AuthService authService; // Declare AuthService variable
  late FirebaseAuth _auth;
  late User? user;
  late String userEmail;
  late List<dynamic> avaliable;
  bool isLoading =
      true; // Adiciona uma variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context, listen: false);
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    userEmail = user?.email ?? '';
    // Carrega as informações do usuário
    _loadUserInfos();
  }

  void _updateProfile() {
    _loadUserInfos(); // Ou qualquer outro método que atualize as informações do perfil
  }

  Future<void> _loadUserInfos() async {
    try {
      infos = await authService.getinfos(userEmail);
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

  Future<String> getImageUrl(String imagePath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref(imagePath);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Erro ao obter a URL da imagem: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Perfil",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(isDark ? Ionicons.sunny : Ionicons.moon),
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
            : SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                     ClipRRect(
  borderRadius: BorderRadius.circular(100),
  child: Image.asset(
    'image/img/user.png',
     height: 100,
    fit: BoxFit.cover, // Isso ajusta a imagem de acordo com o widget pai
  ),
),

                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        userEmail,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      StarBar(rating: avaliable),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Editprofile(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),
                      if (!widget.freeorcli)
                      ProfileMenuWidget(
                        title: 'Criar Projetos',
                        onPress: () {  
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  CriarProjetoScreen(authService: authService,useremail: userEmail,)
                              ),
                            );
                        },
                        icon: Ionicons.paper_plane,
                      ),
                      
                          ProfileMenuWidget(
                        title: 'Meus Projetos',
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectsScreen(authService:authService ,freeorcli:widget.freeorcli ,useremail:userEmail ,)
                              ),
                            );
                          
                        },
                        icon: Ionicons.paper_plane,
                      ),
                      
                      
                      ProfileMenuWidget(
                        title: 'Ajuda',
                        onPress: () {},
                        icon: Ionicons.information,
                      ),
                      if (!widget.freeorcli)
                        ProfileMenuWidget(
                          title: 'Fazer Orçamento',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Filterscreen(
                                  authService: authService,
                                  userEmail: userEmail,
                                ),
                              ),
                            );
                          },
                          icon: Ionicons.business,
                        ),
                      ProfileMenuWidget(
                        title: 'Sair',
                        onPress: () {
                          authService.logout(context);
                        },
                        icon: Ionicons.backspace_outline,
                        endIcon: false,
                        textColor: Colors.red,
                      ),
                    ]))));
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blueAccent.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
            .apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                Ionicons.arrow_forward,
                color: Colors.blue,
              ),
            )
          : null,
    );
  }
}

class StarBar extends StatelessWidget {
  final List<dynamic> rating;
  final double size;

  const StarBar({
    super.key,
    required this.rating,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];

    // Verifica se há avaliações
    if (rating.isEmpty) {
      // Caso não haja avaliações, adiciona estrelas desmarcadas (zeradas)
      for (int i = 0; i < 5; i++) {
        starList.add(Icon(
          Icons.star,
          color: Colors.grey,
          size: size,
        ));
      }
      // Não exibe a nota, já que não há avaliações
      starList.add(const SizedBox(width: 3));
      starList.add(const Text('(0)'));
    } else {
      // Calcula a soma das avaliações
      double avaliableSum = 0;
      for (var i in rating) {
        avaliableSum += double.parse(i);
      }

      avaliableSum = avaliableSum / rating.length;
      int realNumber = avaliableSum.round();
      double partNumber = avaliableSum - realNumber;

      // Adiciona estrelas completas, parciais ou desmarcadas conforme a avaliação
      for (int i = 0; i < 5; i++) {
        if (i < realNumber) {
          starList.add(Icon(
            Icons.star,
            color: Theme.of(context).primaryColor,
            size: size,
          ));
        } else if (i == realNumber && partNumber > 0) {
          starList.add(SizedBox(
            height: size,
            width: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: size,
                ),
                ClipRect(
                  clipper: _Clipper(part: partNumber),
                  child: Icon(
                    Icons.star,
                    color: Theme.of(context).primaryColor,
                    size: size,
                  ),
                ),
              ],
            ),
          ));
        } else {
          starList.add(Icon(
            Icons.star,
            color: Colors.grey,
            size: size,
          ));
        }
      }

      starList.add(const SizedBox(width: 3));
      starList.add(Text('(${realNumber})'));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: starList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final double part;
  _Clipper({required this.part});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width * part, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true; // Redesenha o clip se mudar
  }
}
