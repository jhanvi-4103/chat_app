// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:kd_chat/services/auth/login_or_register.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Image.asset(
          'assets/chatapp.png', 
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
