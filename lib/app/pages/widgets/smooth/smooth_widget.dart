import 'dart:async';


import 'package:app_freelancer/app/pages/widgets/smooth/pages.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Smooth extends StatefulWidget {
  const Smooth({super.key});

  @override
  State<Smooth> createState() => _SmoothState();
}

class _SmoothState extends State<Smooth> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
if (_controller.hasClients) {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage != 4) {
        _currentPage++;
      }
      if (_currentPage == 4) {
        _controller.jumpToPage(
          0,
        );
        _currentPage = 0;
      } else {
        _controller.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 400,
            child: PageView(
              controller: _controller,
              children: const [
                Pages(
                    title: 'Chat-Related News',
                    text:
                        "Introducing Personal Chat - our latest feature that brings a whole new level of communication to your fingertips. With Personal Chat, you can now connect with friends, family, and colleagues in a more intimate and personalized way. Share messages, photos, and videos privately, and enjoy real-time conversations with those who matter most to you.",
                    colors1: Color.fromARGB(255, 0, 0, 0),
                    colors2: Color.fromARGB(255, 0, 0, 0)),
                Pages(
                    title: 'New Settings Features',
                    text:
                        "Discover the latest additions to our settings menu! We're excited to introduce new customization options that allow you to personalize your experience like never before. From theme customization to notification settings, these new features are designed to enhance your user experience and give you more control over how you use our app.",
                    colors1: Color.fromARGB(255, 0, 0, 0),
                    colors2: Color.fromARGB(255, 0, 0, 0)),
                Pages(
                    title: 'New Payment Methods Available',
                    text:
                        "We're thrilled to announce the introduction of new payment methods! Our goal is to make your transactions smoother and more convenient.Whether you prefer credit card, PayPal, or other digital payment methods, we've got you covered. Stay tuned for more updates as we strive to enhance your payment experience!",
                    colors1: Color.fromARGB(255, 0, 0, 0),
                    colors2: Color.fromARGB(255, 0, 0, 0)),
                Pages(
                    title: 'Beta Version Now Available',
                    text:
                        "We're excited to announce that the beta version of our app is now available! This version includes new features and improvements that we're eager for you to try out. As a beta tester, you'll have the opportunity to provide feedback and help us shape the future of our app.",
                    colors1: Color.fromARGB(255, 0, 0, 0),
                    colors2: Color.fromARGB(255, 0, 0, 0)),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 4,
            effect: const ScaleEffect(
              activeDotColor: Color.fromARGB(255, 93, 5, 175),
              dotColor: Color.fromARGB(255, 255, 255, 255),
              dotHeight: 10,
              dotWidth: 10,
              spacing: 16,
            ),
          )
        ],
      ),
    );
  }
}
