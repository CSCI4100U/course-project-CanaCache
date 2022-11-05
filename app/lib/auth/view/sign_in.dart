import "package:flutter/material.dart";
import "package:app/auth/model/auth.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _EmailError = false;
  bool _LoginError = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validateEmail(String? email) {
    if (email!.isEmpty) {}
  }

  hideText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _signIn(BuildContext context) async {
    UserCredential? cred = await UserAuth.signInWithGoogle(context: context);
    //await UserAuth.deleteCurrentUser();
  }

  Widget signInPage() {
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
        ),
        key: _formKey,
        body: Column(children: [
          TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              validator: (value) => validateEmail(value)),
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => hideText())),
          ),
          IconButton(
              onPressed: () => _signIn(context), icon: const Icon(Icons.edit)),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Center(child: Text("Signed In "));
              // Navigate to home page
            }
          }
          return signInPage();
        });
    /*
    
        */
  }
}
