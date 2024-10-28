import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PreRegisterCliente extends StatefulWidget {
  final AuthService authService;
  final String email;
  final String password;
  const PreRegisterCliente({super.key, required this.authService, required this.email, required this.password});

  @override
  State<PreRegisterCliente> createState() => _PreRegisterClienteState();
}

class _PreRegisterClienteState extends State<PreRegisterCliente> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descCotrroler = TextEditingController();
  final TextEditingController _telefoneController= TextEditingController();
  final TextEditingController _cnpjcpfController = TextEditingController();
  bool _isSaving = false;
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }  

  bool _isFormValid() {
    if (_nameController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _descCotrroler.text.isEmpty || 
        _cnpjcpfController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveForm() async {
  if (!_isFormValid()) return;
  setState(() {
    _isSaving = true;
  });

  try {
    await Future.delayed(const Duration(seconds: 2));
    await widget.authService.register_users(widget.email!, widget.password!, 'freelancers');
    await widget.authService.savePreregisterCliente(
      _descCotrroler.text,
      _nameController.text,
      _telefoneController.text,
      _cnpjcpfController.text,
      widget.email,
    );
    setState(() {
      _isSaving = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados salvos com sucesso')),
    );
    _nameController.clear();
    _cnpjcpfController.clear();
    _telefoneController.clear();
    _descCotrroler.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  } catch (e) {
    setState(() {
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar dados: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 30, 81, 250),
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
              const SizedBox(height: 90),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Fale sobre você",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
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
                              controller: _nameController,
                              hint: "Nome completo",
                            ),
                            _buildTextField(
                              controller: _descCotrroler,
                              hint: "Descrição sobre você",
                            ),
                            _buildTextField(
                              controller: _telefoneController,
                              hint: "Telefone",
                            ),
                            _buildTextField(
                              controller: _cnpjcpfController,
                              hint: "CPF/CNPJ",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _saveForm,
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue[900],
                          ),
                          child: Center(
                            child: _isSaving
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Salvar",
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

