import 'package:app_freelancer/Pages/HomeScreen.dart';
import 'package:app_freelancer/Pages/StartScreen.dart';
import 'package:app_freelancer/widgets/Buttons/ButtonsChoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          Row(
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
          Column(
            children: [
              const Icon(
                Icons.language_outlined,
                size: 48,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 120,
                    color: const Color.fromARGB(255, 140, 2, 221),
                    child: const Wrap(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                          "When registering users, you can collect necessary information like email addresses, usernames, and passwords. Be transparent about data collection and use, and provide users with control over their data. Avoid collecting sensitive information without proper security measures. Comply with relevant privacy laws.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                                                ),
                        ),]
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
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
                // Adicione outras validações aqui, se necessário
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
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
          ButtonsChoice(
            titlebutton: 'Confirm',
            color: Colors.green,
            widget: HomeScreen(),
            sizebutton: 16,
          ),
        ],
      ),
    );
  }
}
