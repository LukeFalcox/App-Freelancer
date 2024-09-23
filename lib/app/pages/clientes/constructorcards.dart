// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_freelancer/app/pages/configs/auth_service.dart';

class Constructorcards extends StatefulWidget {
  final String image;
  final String tit;
  final Widget destinationWidget;
  final String email;
  final AuthService authService;
  final String area;

  const Constructorcards({
    Key? key,
    required this.image,
    required this.tit,
    required this.destinationWidget,
    required this.email,
    required this.authService,
    required this.area,
  }) : super(key: key);

  @override
  State<Constructorcards> createState() => _ConstructorcardsState();
}

class _ConstructorcardsState extends State<Constructorcards> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
      await  widget.authService.saveArea(widget.email,widget.area);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.destinationWidget, 
          ),
        );
      },
      child: Container(
        width: 200,
        height: 265,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.image, height: 100),
              const SizedBox(height: 10),
              Text(
                widget.tit,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
