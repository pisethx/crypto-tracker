import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:crypto_tracker/screens/home_screen.dart';
import 'package:crypto_tracker/screens/login_screen.dart';
import 'package:crypto_tracker/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

void initFirebase() async {
  await fetchCrypto('', true);
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initFirebase();

    Timer(
      Duration(seconds: 2),
      () {
        FirebaseAuth.instance.authStateChanges().listen((User user) {
          if (user == null)
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          else
            Navigator.pushReplacementNamed(context, HomeScreen.id);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor, // status bar color
    ));

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.monetization_on, color: Colors.white, size: MediaQuery.of(context).size.width * 0.4),
            Image.asset('assets/nano_white.png', width: MediaQuery.of(context).size.width * 1),
            // SizedBox(height: 24.0),
            // Text('CRYPTO TRACKER', style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
