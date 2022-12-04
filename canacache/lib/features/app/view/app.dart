import "dart:developer";

import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/features/app/controller/app_controller.dart";
import "package:canacache/features/auth/view/sign_in.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class CanaApp extends StatefulWidget {
  const CanaApp({Key? key}) : super(key: key);

  @override
  State<CanaApp> createState() => CanaAppState();
}

class CanaAppState extends ViewState<CanaApp, CanaAppController> {
  CanaAppState() : super(CanaAppController());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: con.providers,
      child: MaterialApp(
        title: "CanaCache",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: con.initialize(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              log(
                "Error initializing app",
                error: snapshot.error,
                stackTrace: snapshot.stackTrace,
              );
              return const Center(child: Text("Error initializing app"));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const SignInForm();
            }
            return const CircularProgressIndicator();
          },
        ),
        routes: CanaRoute.routes,
      ),
    );
  }
}
