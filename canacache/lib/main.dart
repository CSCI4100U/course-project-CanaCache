import "package:canacache/common/utils/routes.dart";
import "package:canacache/features/auth/view/sign_in.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
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
      routes: Routes.routes,
    );
  }
}
