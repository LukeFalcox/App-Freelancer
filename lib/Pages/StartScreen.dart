// ignore_for_file: non_constant_identifier_names

import 'package:app_freelancer/Pages/LoginScreen.dart';
import 'package:app_freelancer/Pages/RegisterScrenn.dart';
import 'package:app_freelancer/widgets/Buttons/ButtonsChoice.dart';
import 'package:app_freelancer/widgets/Gradient/GradiendText.dart';
import 'package:app_freelancer/widgets/Smooth/SmoothScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: GradientText(
                  text: 'CyberFreelancer',
                  gradient:
                      LinearGradient(colors: [Colors.white, Colors.white]),
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 50.0, left: 10.0, right: 30.0, bottom: 40.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.white70,
                      width: 10,
                      height: 150, // Define a largura e altura do quadrado
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        text: 'Welcome',
                        gradient: LinearGradient(colors: [
                          Colors.green.shade300,
                          Colors.yellow.shade600
                        ]),
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w600),
                      ),
                      const Wrap(
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
            Smooth(),
            const SizedBox(
              height: 50,
            ),
             const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonsChoice(
                    titlebutton: 'Login',
                    color: Color(0xFF6ABABD), widget: PageLogin(),
                  ),
      
                 ButtonsChoice(
                    titlebutton: 'Register',
                    color: Color(0xFF67CBB7), widget: Register(),
                  ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}


/*
appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xE0311CD1), Color(0xFF6401CF)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft),
          ),
        ),
        title: const Text(
          'CyberFreelancer',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.question_mark,
              color: Color(0xFFFFFFFF),
            ),
            onPressed: () {},
          ),
        ],
      ),
 Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Welcome in CyberFreelancer',
                      style: TextStyle(
                        color: Color(0xFF00FFEE),
                        fontSize: 24,
                        fontFamily: AutofillHints.jobTitle,
                  fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
                                    Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainerExample(
                  titleText: "Login",
                  titlebutton: "Login Now",
                  descText:
                      "If you have an account already registered with Cyber Freelancer Log in",
                ),
                ),
                                Align(
                alignment: Alignment.centerRight,
                child: AnimatedContainerExample(
                  titleText: "Register",
                  titlebutton: "Register Now",
                  descText:
                      "If you don't have an account already registered with Cyber Freelancer Register Now",
                ),
                                                )

*/
