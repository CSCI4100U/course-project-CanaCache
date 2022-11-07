import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:canacache/common_widgets/cana_appbar.dart";
import "package:canacache/utils/cana_palette.dart";
import "package:canacache/auth/model/auth.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:canacache/common_widgets/cana_appbar_list_item.dart";

class CanaScaffold extends StatefulWidget {
  final String? title;
  final GlobalKey<ScaffoldState> _scaffState = GlobalKey<ScaffoldState>();
  final Widget body;
  List<Widget>? navItems = [];

  CanaScaffold({Key? key, this.title, required this.body, this.navItems})
      : super(key: key);

  @override
  State<CanaScaffold> createState() => _CanaScaffoldState();
}

class _CanaScaffoldState extends State<CanaScaffold> {
  //CanaScaffold({super.key, required this.body});

  List<Widget> generateDrawer(BuildContext context) {
    List<Widget> children = [];

    children.add(
      SizedBox(
        height: 150,
        child: DrawerHeader(
          decoration: const BoxDecoration(
            color: CanaPalette.primaryBG,
          ),
          child: Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SvgPicture.asset(
                "assets/vectors/logo.svg",
                matchTextDirection: true,
              ),
            ),
          ),
        ),
      ),
    );

    // will only append to the list if the user is loged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        children.add(
          CanaAppBarListItem(
            iconData: Icons.home,
            label: "Home",
            callBack: () => Navigator.pushNamed(context, "homePage"),
          ),
        );

        children.add(
          CanaAppBarListItem(
            iconData: Icons.multiline_chart,
            label: "Stats",
            callBack: () => Navigator.pushNamed(context, "statsPage"),
          ),
        );

        children.add(
          CanaAppBarListItem(
            iconData: Icons.settings_applications,
            label: "Settings",
            callBack: () => Navigator.pushNamed(context, "statsPage"),
          ),
        );

        children.add(
          CanaAppBarListItem(
            iconData: Icons.logout,
            label: "Logut",
            callBack: () {
              UserAuth.deleteCurrentUser();
              Navigator.pushReplacementNamed(context, "signInPage");
            },
          ),
        );
      }
    });

    if (widget.navItems != null) {
      children = [...children, ...widget.navItems!];
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CanaAppBar(titleStr: widget.title, scaffState: widget._scaffState),
      key: widget._scaffState,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: generateDrawer(context),
        ),
      ),
      body: widget.body,
    );
  }
}
