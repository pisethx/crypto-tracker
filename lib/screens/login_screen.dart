import 'package:crypto_tracker/widgets/outlined_text_field.dart';
import 'package:crypto_tracker/widgets/primary_button.dart';
import 'package:crypto_tracker/widgets/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/screens/home_screen.dart';
import 'package:crypto_tracker/constants/style.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: kScreenPadding.copyWith(top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign in to Crypto Tracker',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              OutlinedTextField(
                labelText: 'Email',
                hintText: 'you@example.com',
              ),
              SizedBox(height: 30.0),
              OutlinedTextField(
                labelText: 'Password',
                hintText: '*********',
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Forgot Password',
                    style: kPrimaryTextStyle,
                  ),
                  Text(
                    'Privacy Policy',
                    style: kPrimaryTextStyle,
                  )
                ],
              ),
              Spacer(),
              SignInButton(),
              PrimaryButton(
                label: 'Sign in',
                onPressed: () {
                  Navigator.pushNamed(context, HomeScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
