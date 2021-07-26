import 'package:crypto_tracker/screens/home_screen.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/primary_button.dart';
import 'package:crypto_tracker/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatefulWidget {
  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: PrimaryButton(
        loading: _isSigningIn,
        icon: Icon(Icons.login),
        label: 'Sign in with Twitter',
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });
          UserCredential user = await AuthService.signInWithTwitter();
          setState(() {
            _isSigningIn = false;
          });

          if (user != null) return Navigator.pushReplacementNamed(context, HomeScreen.id);

          // if (user != null) {
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(
          //       builder: (context) => GUserInfoScreen(
          //         user: user,
          //       ),
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}
