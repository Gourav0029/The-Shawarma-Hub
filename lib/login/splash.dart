import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_shawarma_hub/login/login.dart';
import 'package:the_shawarma_hub/main_app/landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = GetStorage();
  String name = '';
  @override
  void initState() {
    super.initState();
    name = storage.read('name') ?? '';
    log(name.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo.png', // Your logo asset
      nextScreen: name.isNotEmpty ? const LandingPage() : const LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      backgroundColor: const Color(0xFFFAE3C8),
      splashIconSize: 450,
      duration: 4000, // Duration in milliseconds
    );
  }
}
