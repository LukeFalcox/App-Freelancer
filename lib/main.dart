
import 'package:app_freelancer/app_funcoes/pages/configs/auth_service.dart';
import 'package:app_freelancer/app_funcoes/pages/configs/check_auth_state.dart';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/payments/consts.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Stripe.publishableKey = stripePublishableKey;


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: CheckAuthState(),
  ));
}

