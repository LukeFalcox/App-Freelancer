// ignore: file_names
import 'dart:async';

import 'package:app_freelancer/Pages/StartScreen.dart';
import 'package:app_freelancer/widgets/Buttons/ButtonsChoice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _rememberMe = false;
  double opacity = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _startTimeout();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela o temporizador ao sair da tela
    super.dispose();
  }

  void _startTimeout() {
    const tenMinutes = Duration(minutes: 10);
    _timer = Timer(tenMinutes, () {
      _clearCredentials();
      setState(() {});
    });
  }

  // Método para reiniciar o temporizador
  void _resetTimeout() {
    _timer?.cancel();
    _startTimeout();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('email');
    final String? savedPassword = prefs.getString('password');
    final bool? savedRememberMe = prefs.getBool('rememberMe');

    if (savedRememberMe != null && savedRememberMe) {
      setState(() {
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
        _rememberMe = savedRememberMe;
      });
    }
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setBool('rememberMe', _rememberMe);
  }

  void _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('rememberMe');
    _emailController.clear();
    _passwordController.clear();
    _rememberMe = false;
  }

  void _login() {
    _saveCredentials();
    _resetTimeout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
            child: TextField(
              obscureText: true,
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5),
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
                 onTap: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => HomeScreen(),
                     ),
                   );
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
        ],
      ),
    );
  }
}
