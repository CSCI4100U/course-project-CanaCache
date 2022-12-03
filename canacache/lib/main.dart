import "package:canacache/features/app/view/app.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

void main() async {
  // lock to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const CanaApp());
}
