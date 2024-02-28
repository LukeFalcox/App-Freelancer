// ignore: file_names
import 'dart:async';

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
  Timer? _timer; 

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _startTimeout(); 
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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text('Lembrar-me'),
              ],
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
