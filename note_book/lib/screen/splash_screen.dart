import 'dart:async';
import 'package:flutter/material.dart';
import 'package:note_book/screen/home_screen.dart';
import 'package:note_book/screen/onboarding/onboarding_screen.dart';
import 'package:note_book/services/shared_preferance.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnBoardingBodyScreen(),
            ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.blue.shade600,
          Colors.blue.shade700,
          Colors.blue.shade900,
        ])),
        width: double.infinity,
        child: Center(
          child: Image(
            image: AssetImage("assets/images/logo.png"),
            color: Colors.white,
            height: 180,
            width: 180,
          ),
        ),
      ),
    );
  }
}
