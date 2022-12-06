import "package:canacache/common/widgets/scaffold.dart";
import "package:flutter/material.dart";

class FavouritesView extends StatelessWidget {
  final String? title;

  const FavouritesView({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CanaScaffold(
      title: title,
      body: const SingleChildScrollView(
        child: Text("eue"),
      ),
    );
  }
}
