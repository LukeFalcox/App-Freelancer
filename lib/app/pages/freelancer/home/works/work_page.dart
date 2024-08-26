// ignore_for_file: prefer_const_constructors

import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:app_freelancer/app/pages/freelancer/home/works/workcards.dart';
import 'package:flutter/material.dart';

class Works extends StatefulWidget {
  final AuthService authService;

  const Works({super.key, required this.authService});

  @override
  // ignore: library_private_types_in_public_api
  _WorksState createState() => _WorksState();
}

class _WorksState extends State<Works> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Freelancers",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250),
        elevation: 0,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))),
      ),
      body: Center(
        child: FreelancersCards(
          authService: widget.authService,
        ),
      ),
    );
  }
}
