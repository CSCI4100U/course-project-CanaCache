import "package:flutter/material.dart";
import "package:app/auth/view/sign_in.dart";
import "package:firebase_core/firebase_core.dart";
import "package:app/homepage/view/homepage.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CannaCache",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error intializing Firebase"));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return const SignInForm();
            }
            return const CircularProgressIndicator();
          }),
      routes: {
        "homePage": (context) => const HomePage(),
        "statsPage": (context) => const HomePage(),
        "settingsPage": (context) => const HomePage(),
        "signInPage": (context) => const SignInForm(),
      },
    );
  }
}
