import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/screens/login_screen.dart';
import 'package:crypto_tracker/services/auth.dart';
import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:crypto_tracker/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kScreenPadding.copyWith(top: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Container(
                    child: NetworkPicture(radius: 60, url: AuthService.currentUser.photoURL),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    AuthService.currentUser.displayName,
                    style: kPrimaryTextStyle.copyWith(color: kDarkGrayColor, fontSize: 20.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Buy High, Sell Low",
                    style: kCaptionTextStyle,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 100.0),
          Center(
            child: PrimaryButton(
              icon: Icon(Icons.logout),
              label: 'Log Out',
              onPressed: () async {
                await AuthService.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          )
        ],
      ),
    );
  }
}
