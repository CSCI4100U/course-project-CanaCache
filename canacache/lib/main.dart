import "package:flutter/material.dart";
import "package:canacache/auth/view/sign_in.dart";
import "package:firebase_core/firebase_core.dart";
import "package:canacache/homepage/view/homepage.dart";
import "package:canacache/settings/view/settings_view.dart";
import "package:canacache/theming/models/cana_pallet_provider.dart";
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CanaThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CanaCache",
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error initializing Firebase"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const SignInForm();
          }
          return const CircularProgressIndicator();
        },
      ),
      routes: {
        "homePage": (context) => const HomePage(),
        "statsPage": (context) => const HomePage(),
        "settingsPage": (context) => const SettingsPageView(title: "Settings"),
        "signInPage": (context) => const SignInForm(),
      },
    );
  }
}
