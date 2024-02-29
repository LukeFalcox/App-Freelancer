// import 'dart:async';

// import 'package:shared_preferences/shared_preferences.dart';

// class Shared {
//   bool _rememberMe = false;
//   Timer? _timer; 

  
//   Future<void> _startSettings() async{
//     _loadSavedCredentials();

//   }

  


//   // Método para reiniciar o temporizador
//   void _resetTimeout() {
//     _timer?.cancel(); 
//   }

//   Future<void> _loadSavedCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? savedEmail = prefs.getString('email');
//     final String? savedPassword = prefs.getString('password');
//     final bool? savedRememberMe = prefs.getBool('rememberMe');

//     if (savedRememberMe != null && savedRememberMe) {
//       setState(() {
//         _emailController.text = savedEmail ?? '';
//         _passwordController.text = savedPassword ?? '';
//         _rememberMe = savedRememberMe;
//       });
//     }
//   }

//   Future<void> _saveCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('email', _emailController.text);
//     await prefs.setString('password', _passwordController.text);
//     await prefs.setBool('rememberMe', _rememberMe);
//   }


//   void _clearCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('email');
//     await prefs.remove('password');
//     await prefs.remove('rememberMe');
//     _emailController.clear(); 
//     _passwordController.clear();
//     _rememberMe = false;
//   }

//   void _login() {
//     _saveCredentials();
//     _resetTimeout(); 
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     );
//   }
// }