import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakeUser {
  String get displayName {
    return 'Satoshi Nakamoto';
  }

  String get photoURL {
    return 'https://pbs.twimg.com/profile_images/1413195968883924995/2UhV0Ii6_400x400.jpg' ??
        'https://static.coindesk.com/wp-content/uploads/2021/04/dogecoin.jpg';
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

  static _setUser(user) {
    _user = user;
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

      _setUser(FirebaseAuth.instance.currentUser);

      return response;
    }
  }

  static Future<void> signOut() async {
    final response = await FirebaseAuth.instance.signOut();

    _setUser(_fakeUser);

    return response;
  }
}
