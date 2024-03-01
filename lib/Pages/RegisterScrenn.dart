// ignore_for_file: use_build_context_synchronously, unnecessary_import, file_names

import 'package:app_freelancer/Pages/HomeScreen.dart';
import 'package:app_freelancer/Pages/LoginScreen.dart';
import 'package:app_freelancer/Pages/StartScreen.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Register extends StatefulWidget {

  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
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
          children: [
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
                    'Register Users',
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
                  padding: const EdgeInsets.all(25.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 160,
                      color: const Color.fromARGB(255, 140, 2, 221),
                      child: const Wrap(children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "When registering users, you can collect necessary information like email addresses, usernames, and passwords. Be transparent about data collection and use, and provide users with control over their data. Avoid collecting sensitive information without proper security measures. Comply with relevant privacy laws.",
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
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@gmail.com',
                  focusColor: Colors.blue,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF5F16B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF1B93F5)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFFF73123)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, insert your email.';
                  }
                  if (value.length < 9) {
                    return "This e-mail is very short";
                  }

                  if (!value.contains('@')) {
                    return "This e-mail isn't valid";
                  }
                  // Adicione outras validações aqui, se necessário
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'password_example',
                  focusColor: Colors.blue,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF5F16B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF1B93F5)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFFF73123)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, insert your password.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
              child: TextFormField(
                controller: _confirmpasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  hintText: 'password_example',
                  focusColor: Colors.blue,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF5F16B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF1B93F5)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFFF73123)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please, insert your password.';
                  }
                  // Adicione outras validações aqui, se necessário
                  return null;
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(seconds: 1),
                  child: Card(
                    color: Colors.green,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.green.withAlpha(30),
                      onTap: () async {
                        if (_passwordController.text ==
                            _confirmpasswordController.text) {
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
                        } else {
                          // Senhas não correspondem, exibir mensagem de erro
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content:
                                    const Text("The passwords is not match"),
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
                )),
            const SizedBox(height: 50),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Already a member?'),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => const PageLogin(),
                child: const Text(
                  'Login now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  clickBotao() {
    _authService.registerUsers(
        email: _emailController.text, password: _passwordController.text);
  }

  Future<bool> _authenticateUser() async {
    return true;
  }
}
