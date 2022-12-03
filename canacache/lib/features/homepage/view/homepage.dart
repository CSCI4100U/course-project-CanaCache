import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/homepage/controller/homepage_controller.dart";
import "package:canacache/features/homepage/controller/map_model.dart" as map;
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";

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
    return CanaScaffold(
      title: "Home",
      body: Stack(
        children: [
          FlutterMap(
            options: map.options,
            layers: [
              map.auth,
              map.caches,
            ],
          )
        ],
      ),
    );
  }
}
