import "package:google_sign_in/google_sign_in.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
//import 'package:firebase_core/firebase_core.dart';

class UserAuth {
  // refer to here for docs https://firebase.google.com/docs/auth/flutter/federated-auth
  // a good chunk of the code in this class is taken from the docs listed above
  static Future<UserCredential?> signInWithGoogle(
      {required BuildContext context}) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      var result = await FirebaseAuth.instance.signInWithCredential(credential);
      return result;
    } on Exception catch (error) {
      SnackBar snackBar = SnackBar(
        content: Text("$error"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }

  static Future<UserCredential?> signInWithGithub(
      {required BuildContext context}) async {
    GithubAuthProvider githubProvider = GithubAuthProvider();

    try {
      var result =
          await FirebaseAuth.instance.signInWithProvider(githubProvider);
      return result;
    } on Exception catch (error) {
      SnackBar snackBar = SnackBar(
        content: Text("$error"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }

  static deleteCurrentUser() async {
    await FirebaseAuth.instance.signOut();
  }
}

// for error https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-react-native-android-native-app
