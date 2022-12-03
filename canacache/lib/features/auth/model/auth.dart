import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

// refer to here for docs https://firebase.google.com/docs/auth/flutter/federated-auth
// a good chunk of the code in this file is taken from the docs listed above
Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  if (googleAuth == null) return null; // handle canceling sign in

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential?> signInWithGitHub() async {
  GithubAuthProvider githubProvider = GithubAuthProvider();

  try {
    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  } on FirebaseAuthException catch (e) {
    if (e.code == "web-context-canceled") return null;
    rethrow;
  }
}

Future<void> signOut() => FirebaseAuth.instance.signOut();

// for error https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-react-native-android-native-app
