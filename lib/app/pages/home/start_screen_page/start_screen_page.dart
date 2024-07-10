// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_freelancer/app/pages/home/start_screen_page/sign/login_page.dart';
import 'package:app_freelancer/app/pages/home/start_screen_page/sign/register_page.dart';
import 'package:app_freelancer/app/pages/widgets/buttons/buttons_choice.dart';
import 'package:app_freelancer/app/pages/widgets/gradient/gradient_text.dart';
import 'package:app_freelancer/app/pages/widgets/smooth/smooth_widget.dart';
import 'package:flutter/material.dart';

class StartScreenPage extends StatefulWidget {
  const StartScreenPage({super.key});

  @override
  State<StartScreenPage> createState() => _StartScreenPageState();
}

class _StartScreenPageState extends State<StartScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "CyberFreelancer",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ButtonsChoice(
                titlebutton: 'Login',
                color: Color.fromARGB(255, 102, 27, 149),
                widget: PageLogin(),
                sizebutton: 12,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ButtonsChoice(
                titlebutton: 'Register',
                color: Color.fromARGB(255, 102, 27, 149),
                widget: Register(),
                sizebutton: 12,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 80.0, left: 10.0, right: 30.0, bottom: 40.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        color: Colors.white70,
                        width: 10,
                        height: 150, // Define a largura e altura do quadrado
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          text: 'Welcome',
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 129, 7, 210),
                            Color.fromARGB(255, 129, 7, 210),
                          ]),
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w600),
                        ),
                        Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5, right: 8.0),
                              child: Text(
                                'CyberFreelancer is a true revolution in the world of freelancers, providing an intuitive and efficient platform to connect freelance professionals with incredible opportunities. With an elegant interface and innovative features, CyberFreelancer makes it easier than ever to find freelance jobs that match your skills and interests.',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Text(
                'Features',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Smooth(),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
  }
}
