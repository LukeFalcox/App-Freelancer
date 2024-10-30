import 'dart:async';
import 'package:app_freelancer/app_funcoes/pages/clientes/createworks.dart';
import 'package:app_freelancer/app_funcoes/pages/clientes/filterscreen.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/projects_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_profile/editprofile.dart';
import 'ratingwidget.dart';

class ProfileScreen extends StatefulWidget {
  final bool freeorcli;
  final AuthService authService;

  const ProfileScreen({
    super.key,
    required this.freeorcli,
    required this.authService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String userEmail = '';
  String img = '';
  List<dynamic> avaliable = [];
  bool isLoading = true;
  late User? user;

  @override
  void initState() {
    super.initState();
    _loadUserInfos();
  }

  Future<void> _loadUserInfos() async {
    try {
      user = FirebaseAuth.instance.currentUser;
      userEmail = user?.email ?? '';
      
      final infos = await widget.authService.getinfos(userEmail);
      if (infos != null && infos.isNotEmpty) {
        name = infos['nome'] ?? '';
        avaliable = infos['nota'] ?? [];
      }

      img = await widget.authService.fetchImage(userEmail);
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
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await widget.authService.pickandUploadImage(userEmail);
                      img = await widget.authService.fetchImage(userEmail);
                      setState(() {});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: img.isNotEmpty
                          ? Image.network(img, height: 100, width: 100, fit: BoxFit.cover)
                          : Image.asset('image/img/user.png', height: 100, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    userEmail,
                    style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  StarBar(rating: avaliable),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Editprofile()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
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
                            builder: (context) => CriarProjetoScreen(
                              authService: widget.authService,
                              useremail: userEmail,
                            ),
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
                          builder: (context) => ProjectsScreen(
                            authService: widget.authService,
                            freeorcli: widget.freeorcli,
                            useremail: userEmail,
                          ),
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
                              authService: widget.authService,
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
                      widget.authService.logout(context);
                    },
                    icon: Ionicons.backspace_outline,
                    endIcon: false,
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

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
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14).apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Ionicons.arrow_forward, color: Colors.blue),
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
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];

    if (rating.isEmpty) {
      for (int i = 0; i < 5; i++) {
        starList.add(const Icon(Icons.star, color: Colors.grey, size: 15));
      }
      starList.add(const SizedBox(width: 3));
      starList.add(const Text('(0)'));
    } else {
      double avaliableSum = rating.map((e) => double.parse(e)).reduce((a, b) => a + b) / rating.length;
      int fullStars = avaliableSum.floor();
      double partStar = avaliableSum - fullStars;

      for (int i = 0; i < 5; i++) {
        if (i < fullStars) {
          starList.add(Icon(Icons.star, color: Theme.of(context).primaryColor, size: size));
        } else if (i == fullStars && partStar > 0) {
          starList.add(SizedBox(
            height: size,
            width: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                 Icon(Icons.star, color: Colors.grey, size: size),
                ClipRect(
                  clipper: _Clipper(part: partStar),
                  child: Icon(Icons.star, color: Theme.of(context).primaryColor, size: size),
                ),
              ],
            ),
          ));
        } else {
          starList.add( Icon(Icons.star, color: Colors.grey, size: size));
        }
      }
      starList.add(const SizedBox(width: 3));
      starList.add(Text('(${fullStars})'));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: starList);
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
    return true;
  }
}
