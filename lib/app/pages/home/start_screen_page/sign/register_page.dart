// ignore_for_file: use_build_context_synchronously, unnecessary_import, file_names

import 'package:app_freelancer/app/pages/home/home_page.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/start_screen_page.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/sign/login_page.dart';
import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _usernameController = TextEditingController();
  double opacity = 0.0;

  sigUp() async {
    if (_passwordController.text != _confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Different passwords"),
      ));
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      authService.registerUsers(_usernameController.text, _emailController.text,
          _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

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
                              builder: (context) => const StartScreenPage()),
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
                style: const TextStyle(color: Colors.white),
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  hintText: 'ExampleName',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
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
                    return 'Please, insert your username.';
                  }
                  if (value.length < 9) {
                    return "This username is very short";
                  }

                  if (!value.contains('@')) {
                    return "This username isn't valid";
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
                style: const TextStyle(color: Colors.white),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@gmail.com',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
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
                style: const TextStyle(color: Colors.white),
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'password_example',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
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
                style: const TextStyle(color: Colors.white),
                controller: _confirmpasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  hintText: 'password_example',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
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
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            key: Key('authDialog'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Autenticando...'),
                              ],
                            ),
                          );
                        },
                      );

                      try {
                        await sigUp();

                        Navigator.pop(context);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } catch (error) {
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('Erro ao autenticar: $error'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Confirm'),
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
}
