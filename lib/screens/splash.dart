import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project/screens/login.dart';
import 'package:project/screens/user/home.dart';

import 'bottom/bottom.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  void initState() {
    super.initState();
    _checkUserLogin();
  }

  void _checkUserLogin() {
    Timer(Duration(seconds: 3), () async {
      User? user = FirebaseAuth.instance.currentUser;

      // If the user is logged in
      if (user != null) {
        // Navigate based on user type (admin or normal user)
        if (user.email == "admin@gmail.com") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Bot1())); // Admin Dashboard
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home1())); // Home page for regular users
        }
      } else {
        // If no user is logged in, go to the login screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login1()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset("assets/images/food.json",frameRate: FrameRate.max),
      ),
    );
  }
}
