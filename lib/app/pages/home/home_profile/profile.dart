import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40,),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'ABOUT ACCOUNT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
             Container(
      child: Image.network('https://www.google.com/imgres?imgurl=https%3A%2F%2Fstorage.googleapis.com%2Fgweb-uniblog-publish-prod%2Fimages%2FAndroid_symbol_green_2.max-1500x1500.png&imgrefurl=https%3A%2F%2Fwww.blog.google%2Fproducts%2Fandroid%2F&docid=SDYhQ-MI_6500M&tbnid=rL2RK3y7U-kTxM%3A&vet=10ahUKEwiY0p7Ey5TmAhXkIbkGHYlbBtMQMwh3KAAwAA..i&w=1500&h=803&bih=635&biw=1024&q=android&ved=0ahUKEwiY0p7Ey5TmAhXkIbkGHYlbBtMQMwh3KAAwAA&iact=mrc&uact=8'),
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(image: AssetImage()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
    ),
          ],
        ),
      ),
    );
  }
}
