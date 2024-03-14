import 'package:app_freelancer/Pages/ChoiceClientorFreelanncer/ChoiceFreelancer.dart';
import 'package:app_freelancer/configs/CheckAuthState.dart';
import 'package:app_freelancer/configs/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return   const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CyberFreenlancer',
        home: FreelancerOrClient());
  }
}
