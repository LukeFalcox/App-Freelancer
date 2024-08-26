import 'package:app_freelancer/app/buildfun.dart';
import 'package:app_freelancer/app/pages/buillist.dart';
import 'package:app_freelancer/app/pages/freelancer/home/start_screen_page/sign/login_page.dart';
import 'package:app_freelancer/app/pages/freelancer/home/start_screen_page/sign/register_page.dart';
import 'package:flutter/material.dart';

class HomePrincip extends StatefulWidget {
  const HomePrincip({super.key});

  @override
  State<HomePrincip> createState() => _HomePrincipState();
}

class _HomePrincipState extends State<HomePrincip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                  Color.fromARGB(255, 30, 81, 250),
                  Color.fromARGB(255, 15, 70, 253),
                  Color.fromARGB(255, 0, 38, 255)
                ])),
                child: Column(children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Bem Vindo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Ao",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "CyberFreelancer",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  "Oque é o CyberFreelancer?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.blue.shade700),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "O Cyber Freelancer é uma plataforma inovadora que conecta jovens talentos em tecnologia e outras áreas com oportunidades de trabalho remoto e autônomo.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Quais são as vantagens do Freelancer?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.blue.shade700),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: BuildList(
                                        img: [
                                          "image/img/remuneration.png",
                                          "image/img/flexibility.png",
                                          "image/img/increase_portfolio.png",
                                          "image/img/work_aut.png",
                                        ],
                                        tit: [
                                          "Remuneração Ágil",
                                          "Flexibilidade",
                                          "Aumento de Portfólio",
                                          "Trabalho Autônomo"
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Quais são as vantagens dos Clientes?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.blue.shade700),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                const Center(
                                  child: BuildList(
                                    img: [
                                      "image/img/networking.png",
                                      "image/img/choice.png",
                                      "image/img/sale_acess.png",
                                      "image/img/scalability.png",
                                    ],
                                    tit: [
                                      "Networking",
                                      "Escolha dinâmica",
                                      "Preços Acessíveis",
                                      "Escalabilidade"
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Como Funciona?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.blue.shade700),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                const Center(
                                  child: BuildFun(
                                    img: [
                                      "image/img/description.png",
                                      "image/img/freelancers.png",
                                      "image/img/contact.png",
                                    ],
                                    tit: [
                                      "Faça um orçamento",
                                      "Encontre freelancers correspondentes",
                                      "Entre em contato e realize seu projeto"
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Pronto para começar?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.blue.shade700),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Register(),
                                            ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 30, 81, 250),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        "Cadastre-se Agora",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PageLogin(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 30, 81, 250),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        "Faça o Login Agora",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ])))
                ]))));
  }
}
// const SizedBox(height: 30),
//                 Text(
//                   "Depoimentos",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                       color: Colors.blue.shade700),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),