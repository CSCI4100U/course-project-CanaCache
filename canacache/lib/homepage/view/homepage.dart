import "package:flutter/material.dart";
import "package:canacache/common_widgets/cana_scaffold.dart";

class HomePage extends StatefulWidget {
  final String? title;

  const HomePage({Key? key, this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CanaScaffold(body: const Center(child: Text("Te")));
  }
}
