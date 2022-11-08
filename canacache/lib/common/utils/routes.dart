import "package:canacache/features/auth/view/sign_in.dart";
import "package:canacache/features/homepage/view/homepage.dart";
import "package:flutter/material.dart";

class Routes {
  static const home = "homePage";
  static const stats = "statsPage";
  static const settings = "settingsPage";
  static const signIn = "signInPage";

  static final Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const HomePage(),
    stats: (context) => const HomePage(),
    settings: (context) => const HomePage(),
    signIn: (context) => const SignInForm(),
  };
}
