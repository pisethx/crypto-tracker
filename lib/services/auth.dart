import 'package:crypto_tracker/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakeUser {
  String get displayName {
    return 'Satoshi Nakamoto';
  }

  String get photoURL {
    return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqKOE5A-kQb2c5yJS88yGax-cTwn609D3GGH2myGwPU-H_bTVOU3Hq9GaEmtFh6uU_UIY&usqp=CAU';
  }
}

class AuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  static FakeUser _fakeUser = FakeUser();
  static dynamic _user = _fakeUser;

  static get isAuthenticated {
    return _user != _fakeUser;
  }

  static get currentUser {
    return _user;
  }

  static setUser(user) {
    _user = user;
    Database.userUid = user.uid;
  }

  static removeUser() {
    _user = _fakeUser;
  }

  static Future<UserCredential> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final TwitterLogin twitterLogin = TwitterLogin(
      consumerKey: dotenv.env['TWITTER_API_KEY'],
      consumerSecret: dotenv.env['TWITTER_API_SECRET'],
    );

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();

    if (loginResult.status == TwitterLoginStatus.loggedIn) {
      // Get the Logged In session
      final TwitterSession twitterSession = loginResult.session;

      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token,
        secret: twitterSession.secret,
      );

      // Once signed in, return the UserCredential
      final response = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

      print(response);

      setUser(FirebaseAuth.instance.currentUser);

      return response;
    }
  }

  static Future<void> signOut() async {
    final response = await FirebaseAuth.instance.signOut();

    return response;
  }
}
