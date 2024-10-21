import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_page.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/start_screen_page/sign/register_page.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  double opacity = 0.0;

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
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ícone de seta
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250), // Cor do AppBar
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color.fromARGB(255, 30, 81, 250),
            Color.fromARGB(255, 15, 70, 253),
            Color.fromARGB(255, 0, 38, 255)
          ])),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Seja Bem Vindo",
                      style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                    )
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
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200))),
                                child:  TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                )),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child:  TextField(
                                 controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: "Senha",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Esqueceu a senha?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                     ElevatedButton(
  onPressed: () async {
    // Inicia a ação de login
    setState(() {
      // Aqui você pode adicionar algum estado, como um indicador de carregamento
    });

    try {
      // Tenta fazer o login usando o serviço de autenticação
      UserCredential userCredential = await authService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Verifica se o usuário foi autenticado
      if (userCredential.user != null) {
        // Navega para a HomePage se o login for bem-sucedido
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        // Exibe uma mensagem de erro se o usuário não for autenticado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha no login. Tente novamente.'),
          ),
        );
      }
    } catch (e) {
      // Exibe uma mensagem de erro em caso de exceção
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer login: ${e.toString()}'),
        ),
      );
    } finally {
      // Atualiza o estado, caso precise restaurar algum estado após a operação
      setState(() {
        // Você pode alterar o estado aqui, se necessário (por exemplo, remover o indicador de carregamento)
      });
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 0, 58, 248),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 50),
    elevation: 5,
  ),
  child: const Text(
    "Login",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                        child: const Text(
                          "Não tem uma conta? Cadastre-se",
                          style: TextStyle(
                              color: Color.fromARGB(255, 73, 73, 73)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



 