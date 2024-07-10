import 'package:app_freelancer/app/pages/configs/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterFrelacer extends StatefulWidget {
  const RegisterFrelacer({super.key});

  @override
  State<RegisterFrelacer> createState() => _RegisterFrelacerState();
}

class _RegisterFrelacerState extends State<RegisterFrelacer> {
   final TextEditingController _usernameController = TextEditingController();
   final TextEditingController _cepController = TextEditingController();
   final TextEditingController _phoneController = TextEditingController();
    late String cep;
    late String phone;

  transformvars(String cep,String phone) async{
    if (cep.length == 8) {
     this.cep =  "${cep.substring(0, 5)}-${cep.substring(5)}";

    }
     if (phone.length == 13 ) {
     this.phone = "${phone.substring(0,0)}+${phone.substring(0)}";
     this.phone = "${phone.substring(0,3)} ${phone.substring(3)}";
     this.phone = "${phone.substring(0,6)} ${phone.substring(6)}";
     this.phone =  "${phone.substring(0, 12)}-${phone.substring(12)}";

    }
  }

  entrar(username,cep,phone) async {
    
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Informações para complemento do cadastro',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              width: 600,
              height: 400,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-1.5, 5),
                        blurRadius: 10,
                        blurStyle: BlurStyle.normal)
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      child: TextFormField(
                        
                        style: const TextStyle(color: Colors.white),
                         controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'UserName',
                          hintText: 'Example Name',
                          
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          focusColor: Colors.blue,
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF5F16B8)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                         controller: _cepController,
                        decoration: const InputDecoration(
                          labelText: 'CEP',
                          hintText: 'Example 06526-120',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          focusColor: Colors.blue,
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF5F16B8)),
                          ),
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                         controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Number of Celphone',
                          hintText: '98953-6632',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          focusColor: Colors.blue,
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF5F16B8)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 90,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedOpacity(
                  opacity: 0.8,
                  duration: const Duration(seconds: 1),
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            key: Key('authDialog'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Autenticando...'),
                              ],
                            ),
                          );
                        },
                      );

                      try {
                          transformvars(_cepController.text, _phoneController.text);
                          entrar(_usernameController, cep, phone);
                        Navigator.pop(context);
                      } catch (error) {
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('Erro ao autenticar: $error'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                )),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}





//         Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20),
//               child: TextFormField(
//                 style: const TextStyle(color: Colors.white),
//                 // controller: _usernameController,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
//                   labelText: 'Number Of Phone',
//                   hintText: 'ExampleName',
//                   labelStyle: TextStyle(color: Colors.white),
//                   hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
//                   focusColor: Colors.blue,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFF5F16B8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFF1B93F5)),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFFF73123)),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please, insert your username.';
//                   }
//                   if (value.length < 9) {
//                     return "This username is very short";
//                   }
        
//                   if (!value.contains('@')) {
//                     return "This username isn't valid";
//                   }
//                   // Adicione outras validações aqui, se necessário
//                   return null;
//                 },
//               ),
//             ),
//              const SizedBox(height: 50,),
//         Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20),
//               child: TextFormField(
//                 style: const TextStyle(color: Colors.white),
//                 // controller: _usernameController,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
//                   labelText: 'Date of nasc',
//                   hintText: 'ExampleName',
//                   labelStyle: TextStyle(color: Colors.white),
//                   hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
//                   focusColor: Colors.blue,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFF5F16B8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFF1B93F5)),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFFF73123)),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please, insert your username.';
//                   }
//                   if (value.length < 9) {
//                     return "This username is very short";
//                   }
        
//                   if (!value.contains('@')) {
//                     return "This username isn't valid";
//                   }
//                   // Adicione outras validações aqui, se necessário
//                   return null;
//                 },
//               ),
//             ),
//              const SizedBox(height: 50,),
//         Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20),
//               child: TextFormField(
//                 style: const TextStyle(color: Colors.white),
//                 // controller: _usernameController,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
//                   labelText: 'CEP',
//                   hintText: 'ExampleName',
//                   labelStyle: TextStyle(color: Colors.white),
//                   hintStyle: TextStyle(color: Color.fromARGB(255, 27, 27, 27)),
//                   focusColor: Colors.blue,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFF5F16B8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFF1B93F5)),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(width: 3, color: Color(0xFFF73123)),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please, insert your username.';
//                   }
//                   if (value.length < 9) {
//                     return "This username is very short";
//                   }
        
//                   if (!value.contains('@')) {
//                     return "This username isn't valid";
//                   }
//                   // Adicione outras validações aqui, se necessário
//                   return null;
//                 },
//               ),
//             ),