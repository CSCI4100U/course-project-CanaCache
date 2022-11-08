import "dart:async";
import "package:firebase_auth/firebase_auth.dart";

class SignInListener {
  StreamSubscription? _sub;

  void listen(void Function(String email) onSuccessfulSignIn) {
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        onSuccessfulSignIn(user.email ?? "<unknown>");
      }
    });
  }

  void cancel() => _sub?.cancel();
}
