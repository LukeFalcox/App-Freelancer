import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/home_profile/editprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:html' as html;
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  Map<String, dynamic>? infos;
  late AuthService authService; // Declare AuthService variable
  late FirebaseAuth _auth;
  late User? user;
  String? _profileImageUrl;
  late String userEmail;
  bool isLoading = true; // Adiciona uma variável para controlar o estado de carregamento

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> _loadUserInfos() async {
    try {
      infos = await authService.getinfos(userEmail);
      if (infos != null && infos!.isNotEmpty) {
        name = infos!['nome'] ?? "";
        // Optionally, you might want to load the profile image URL here
        // Example: _profileImageUrl = await authService.getProfileImageUrl(userEmail);
      }
    } catch (e) {
      print("Erro ao carregar informações do usuário: $e");
    } finally {
      setState(() {
        isLoading = false; // Define como false após o carregamento
      });
    }
  }

  Future<String?> pickAndUploadImageMobile(String userEmail) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final File fileObj = File(file.path);
      try {
        final Uint8List fileBytes = await fileObj.readAsBytes();
        final ref = FirebaseStorage.instance.ref().child('images/$userEmail/Usuario/Perfil.jpg');
        final uploadTask = ref.putData(fileBytes);
        await uploadTask.whenComplete(() => null);
        return await ref.getDownloadURL();
      } catch (e) {
        print("Erro no upload: $e");
        return null;
      }
    }
    return null;
  }

  Future<String?> pickAndUploadImageWeb(String userEmail) async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    final Completer<String?> completer = Completer<String?>();
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((_) async {
          final Uint8List fileBytes = reader.result as Uint8List;
          final ref = FirebaseStorage.instance.ref().child('images/$userEmail/Usuario/Perfil.jpg');
          try {
            final uploadTask = ref.putData(fileBytes);
            await uploadTask.whenComplete(() => null);
            final imageUrl = await ref.getDownloadURL();
            completer.complete(imageUrl);
          } catch (e) {
            print("Erro no upload: $e");
            completer.complete(null);
          }
        });

        reader.onError.listen((e) {
          print("Erro no upload: $e");
          completer.complete(null);
        });
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<void> pickAndUploadImage(String userEmail) async {
    String? imageUrl;
    if (kIsWeb) {
      imageUrl = await pickAndUploadImageWeb(userEmail);
    } else {
      imageUrl = await pickAndUploadImageMobile(userEmail);
    }

    if (imageUrl != null) {
      setState(() {
        _profileImageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          ? Center(child: CircularProgressIndicator()) // Exibe o indicador de progresso enquanto carrega
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => pickAndUploadImage(userEmail),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _profileImageUrl != null
                              ? Image.network(_profileImageUrl!)
                              : const Image(
                                  image: AssetImage("image/img/hacker.png"),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Editprofile(),
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
                    ProfileMenuWidget(
                      title: 'Configurações',
                      onPress: () {},
                      icon: Ionicons.cog,
                    ),
                    ProfileMenuWidget(
                      title: 'Meus Projetos',
                      onPress: () {},
                      icon: Ionicons.paper_plane,
                    ),
                    ProfileMenuWidget(
                      title: 'Ajuda',
                      onPress: () {},
                      icon: Ionicons.information,
                    ),
                    ProfileMenuWidget(
                      title: 'Sair',
                      onPress: () {},
                      icon: Ionicons.backspace_outline,
                      endIcon: false,
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
    );
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
