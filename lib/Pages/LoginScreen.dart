// ignore: file_names
// ignore_for_file: use_build_context_synchronously, file_names, duplicate_ignore

import 'dart:async';

import 'package:app_freelancer/Pages/RegisterScrenn.dart';
import 'package:app_freelancer/Pages/StartScreen.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:app_freelancer/Pages/HomeScreen.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _rememberMe = false;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StartScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 32,
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Login Users',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(
                  Icons.language_outlined,
                  size: 48,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 180,
                      color: const Color.fromARGB(255, 140, 2, 221),
                      child: const Wrap(children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "During login, users provide their credentials, like a username and password, to access their account. Secure authentication methods and encryption protect this information. Offering account recovery options and following privacy regulations ensure a safe login process.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
              child: TextField(
                obscureText: false,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@gmail.com',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFF5F16B8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFF1B93F5),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFFF73123),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'password_example',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFF5F16B8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFF1B93F5),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFFF73123),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  activeColor: Colors.green,
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Remind me',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(seconds: 1),
              child: Card(
                color: Colors.green,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.green.withAlpha(30),
                  onTap: () async {
                    // Coloque aqui a lógica de autenticação, e.g., FirebaseAuth.instance.signInWithEmailAndPassword(email, password)
                    // Substitua isso pela lógica de autenticação real
                    bool isAuthenticated = await _authenticateUser();
                    await clickBotao();
                    if (isAuthenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Authentication failed"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const SizedBox(
                    width: 100,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Not is a member?'),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => const Register(),
                child: const Text(
                  'Register now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  clickBotao() async{
   await  _authService.loginUsers(
        email: _emailController.text, password: _passwordController.text);
  }

  Future<bool> _authenticateUser() async {
    return true;
  }
}
