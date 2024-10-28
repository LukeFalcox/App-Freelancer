// import 'package:app_freelancer/app_funcoes/pages/configs/stripe_services.dart';
// import 'package:flutter/material.dart';
// import 'package:universal_platform/universal_platform.dart';
// import 'package:flutter_stripe_web/flutter_stripe_web.dart';


// class Paymentscreen extends StatefulWidget {
//   const Paymentscreen({super.key});

//   @override
//   State<Paymentscreen> createState() => _PaymentscreenState();
// }

// class _PaymentscreenState extends State<Paymentscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Stripe Pagamentos Demo"),
//       ),
//       body: SizedBox.expand(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             MaterialButton(
//               onPressed: () {
//                 StripeService.instance.makePayment(context);
//               },
//               color: Colors.green,
//               child: const Text("Purchase"),
//             ),
//             // Verifique se é Web para mostrar o PaymentElement
//             if (UniversalPlatform.isWeb) ...[
//               // Exiba o PlatformPaymentElement se estiver na Web
//               FutureBuilder<String?>(
//                 future: StripeService.instance.createPaymentIntentForWeb(10, "brl"),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else if (snapshot.hasData) {
//                     return PlatformPaymentElement(snapshot.data);
//                   } else {
//                     return Text("Erro ao obter clientSecret.");
//                   }
//                 },
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlatformPaymentElement extends StatelessWidget {
//   final String? clientSecret;

//   const PlatformPaymentElement(this.clientSecret, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Exibe um botão para confirmar o pagamento
//         ElevatedButton(
//           onPressed: () async {
//             try {
//               await WebStripe.instance.confirmPaymentElement(
//                 ConfirmPaymentElementOptions(
//                   confirmParams: ConfirmPaymentParams(
//                     return_url: Uri.base.toString(),
//                   ),
//                 ),
//               );
//             } catch (e) {
//               print("Erro ao confirmar o pagamento: $e");
//             }
//           },
//           child: const Text("Confirmar Pagamento"),
//         ),
//       ],
//     );
//   }
// }


