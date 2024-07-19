import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'register_page.dart';

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: SafeArea(
          child: Column(
            children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  "Tela de Login",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 115, 183, 247),
                  labelText: 'Usuário',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 115, 183, 247),
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Color.fromARGB(255, 115, 183, 247), width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                  )
                ),
                child: Text("Entrar"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Color.fromARGB(255, 115, 183, 247), width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                  ),
                ),
                child: Text("Cadastrar-se")
              ),
            )
        ],
      ),
    ),
  ),
);
}
}

