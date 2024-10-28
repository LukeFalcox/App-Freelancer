// import 'package:app_freelancer/app_funcoes/pages/freelancer/home/payments/consts.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe_web/flutter_stripe_web.dart';
// import 'package:universal_platform/universal_platform.dart';

// class StripeService {
//   StripeService._();

//   static final StripeService instance = StripeService._();

//   // Adicione este método à sua classe StripeService
// Future<String?> createPaymentIntentForWeb(int amount, String currency) async {
//   try {
//     final Dio dio = Dio();
//     Map<String, dynamic> data = {
//       "amount": _calculateAmount(amount),
//       "currency": currency,
//     };

//     var response = await dio.post(
//       "https://api.stripe.com/v1/payment_intents",
//       data: data,
//       options: Options(
//         contentType: Headers.formUrlEncodedContentType,
//         headers: {
//           "Authorization": "Bearer $stripesecretKey", // Certifique-se que essa variável contém sua chave secreta
//           "Content-Type": 'application/x-www-form-urlencoded',
//         },
//       ),
//     );

//     // Verificar se a resposta contém o client_secret
//     if (response.data != null && response.data["client_secret"] != null) {
//       return response.data["client_secret"];
//     }
//     return null;
//   } catch (e) {
//     print("Erro ao criar PaymentIntent para Web: $e");
//   }
//   return null;
// }


//   Future<void> makePayment(BuildContext context) async {
//     try {
//       // Cria o PaymentIntent e obtém o client secret
//       String? paymentIntentClientSecret = await _createPaymentIntent(10, "brl");
//       if (paymentIntentClientSecret == null) return;

//       if (UniversalPlatform.isWeb) {
//         // Fluxo de pagamento para Web
//         await _initiateWebPayment(context, paymentIntentClientSecret);
//       } else {
//         // Fluxo de pagamento para Mobile (Android/iOS)
//         await _initiateMobilePayment(context, paymentIntentClientSecret);
//       }
//     } catch (e) {
//       print("Erro durante o pagamento: $e");
//     }
//   }

//   Fluxo de Pagamento para Web
// Future<void> _initiateWebPayment(BuildContext context, String clientSecret) async {
//   try {
//  PaymentIntent  result =  await WebStripe.instance.confirmPaymentElement(
//       const ConfirmPaymentElementOptions(
//         confirmParams: ConfirmPaymentParams(
//           return_url: 'http://localhost:55788/return',
//         ),
//       ),
//     );
//         print(result);
//   } catch (e) {
//     print("Erro durante o pagamento na Web: $e");

//   }
// }


//   // Fluxo de Pagamento para Mobile (Android/iOS)
//   Future<void> _initiateMobilePayment(BuildContext context, String clientSecret) async {
//     try {
//       // Inicializa a PaymentSheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: "Kaitoba",
//         ),
//       );

//       // Apresenta a PaymentSheet
//       await _processPayment();
//     } catch (e) {
//       print("Erro durante o pagamento: $e");
//     }
//   }

//   // Criação do PaymentIntent
//   Future<String?> _createPaymentIntent(int amount, String currency) async {
//     try {
//       final Dio dio = Dio();
//       Map<String, dynamic> data = {
//         "amount": _calculateAmount(amount),
//         "currency": currency,
//       };

//       var response = await dio.post(
//         "https://api.stripe.com/v1/payment_intents",
//         data: data,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             "Authorization": "Bearer $stripesecretKey", // Certifique-se que essa variável contém sua chave secreta
//             "Content-Type": 'application/x-www-form-urlencoded',
//           },
//         ),
//       );

//       // Verificar se a resposta contém o client_secret
//       if (response.data != null && response.data["client_secret"] != null) {
//         return response.data["client_secret"];
//       }
//       return null;
//     } catch (e) {
//       print(e);
//     }
//     return null;
//   }

//   // Processa o pagamento (para mobile)
//   Future<void> _processPayment() async {
//     try {
//       // Apresenta a PaymentSheet
//       await Stripe.instance.presentPaymentSheet();
//     } on Exception catch (e) {
//       if (e is StripeException) {
//         print("StripeException: ${e.error.localizedMessage}");
//       } else {
//         print("Erro ao processar o pagamento: $e");
//       }
//     }
//   }

//   // Calcula o valor em centavos (padrão para Stripe)
//   String _calculateAmount(int amount) {
//     final calculatedAmount = amount * 100; // Multiplica por 100 para obter centavos
//     return calculatedAmount.toString();
//   }

//   // Retorna a URL completa (para Web)
// //   String _getReturnUrl() {
// //     return ; // ou o URL do ngrok
// // }

// }
