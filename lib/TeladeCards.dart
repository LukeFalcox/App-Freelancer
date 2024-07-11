
import 'package:flutter/material.dart';
import 'cards.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CardWidget(
                title: 'Freelancer',
                description: 'Entre na sua conta de freelancer.',
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              CardWidget(
                title: 'Cliente',
                description: 'Entre na sua conta de cliente.',
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

