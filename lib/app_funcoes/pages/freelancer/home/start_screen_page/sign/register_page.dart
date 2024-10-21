import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/start_screen_page/sign/login_page.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/start_screen_page/sign/pre-register.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/start_screen_page/sign/proffisional.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool isLoading = false;

  // Função de validação de email
  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Função de cadastro de usuário
  Future<void> signUp(String type) async {
    if (_passwordController.text != _confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    if (!_isEmailValid(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email inválido")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Exibe um SnackBar informando que o cadastro está em andamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cadastro em andamento..."),
        duration: Duration(seconds: 3), // Mantém a mensagem por 3 segundos
      ),
    );

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.register_users(_emailController.text, _passwordController.text, type);

      setState(() {
        isLoading = false;
      });

      // Se for freelancer, navega para a tela Profissional
      if (type == 'freelancers') {
        await authService.savePreregister('default','default',[],'default','default',0,'default');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Profissional(authService: authService)),
        );
      } else {
        // Se for cliente, navega para a tela PreRegister
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PreRegister(authService: authService)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 30, 81, 250),
                Color.fromARGB(255, 15, 70, 253),
                Color.fromARGB(255, 0, 38, 255),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Cadastro",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Crie sua conta",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            _buildTextField(
                              controller: _emailController,
                              hint: "Email",
                              isPassword: false,
                            ),
                            _buildTextField(
                              controller: _passwordController,
                              hint: "Senha",
                              isPassword: true,
                            ),
                            _buildTextField(
                              controller: _confirmpasswordController,
                              hint: "Confirmar Senha",
                              isPassword: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => signUp('freelancers'), // Passa a função corretamente
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 35, 230),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Cadastrar como Freelancer",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () => signUp('clientes'), // Passa a função corretamente
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 35, 230),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Cadastrar como Cliente",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PageLogin()),
                          );
                        },
                        child: const Text(
                          "Já tem uma conta? Faça login",
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                      const SizedBox(height: 30),
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

  // Função para construção dos campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
