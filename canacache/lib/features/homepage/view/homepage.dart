import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/homepage/controller/homepage_controller.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  final String? title;

  const HomePage({Key? key, this.title}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends ViewState<HomePage, HomePageController> {
  HomePageState() : super(HomePageController());

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Te"));
  }
}
