
import 'package:app_freelancer/app/pages/configs/check_auth_state.dart';
import 'package:app_freelancer/app/pages/home/home_profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CyberFreenlancer',
        home: CheckAuthStatePage());
  }
  }
