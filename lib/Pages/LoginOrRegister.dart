// ignore_for_file: file_names

import 'package:app_freelancer/Pages/LoginScreen.dart';
import 'package:app_freelancer/Pages/RegisterScrenn.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return const PageLogin();
    } else {
      return const Register();
    }
  }
}
