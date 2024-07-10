
import 'package:app_freelancer/app/pages/home/start_screen_page/start_screen_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CyberFreenlancer',
        home: StartScreenPage());
  }
  }
