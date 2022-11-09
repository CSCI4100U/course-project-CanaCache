import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/widgets/appbar.dart";
import "package:canacache/common/widgets/appbar_list_item.dart";
import "package:canacache/features/auth/model/auth.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:provider/provider.dart";

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
  List<Widget> generateDrawer(BuildContext context) {
    List<Widget> children = [];

    children.add(
      SizedBox(
        height: 150,
        child: DrawerHeader(
          decoration: BoxDecoration(
            color: Provider.of<SettingsProvider>(context)
                .getTheme()
                .primaryBgColor,
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

    Map<String, Widget> canidateItems = {
      Routes.home: const CanaAppBarListItem(
        iconData: Icons.home,
        label: "Home",
        route: Routes.home,
      ),
      Routes.stats: const CanaAppBarListItem(
        iconData: Icons.multiline_chart,
        label: "Stats",
        route: Routes.stats,
      ),
      Routes.settings: const CanaAppBarListItem(
        iconData: Icons.settings_applications,
        label: "Settings",
        route: Routes.settings,
      ),
      Routes.logout: const CanaAppBarListItem(
        iconData: Icons.logout,
        label: "Logout",
        route: Routes.logout,
        clearNavigation: true,
        callback: UserAuth.deleteCurrentUser,
      ),
      Routes.signIn: const CanaAppBarListItem(
        iconData: Icons.account_box,
        label: "Sign In",
        route: Routes.signIn,
        clearNavigation: true,
      ),
    };

    List<String> requiredItems = [];

    // will only append to the list if the user is logged in
    //FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (FirebaseAuth.instance.currentUser != null) {
      requiredItems.addAll([
        Routes.home,
        Routes.stats,
        Routes.settings,
        Routes.logout,
      ]);
    } else {
      requiredItems.addAll([Routes.settings, Routes.signIn]);
    }

    requiredItems.forEach((element) => children.add(canidateItems[element]!));
    //});

    if (widget.navItems != null) {
      children = [...children, ...widget.navItems!];
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanaAppBar(title: widget.title, scaffState: widget._scaffState),
      backgroundColor:
          Provider.of<SettingsProvider>(context).getTheme().secBgColor,
      key: widget._scaffState,
      drawer: Drawer(
        backgroundColor:
            Provider.of<SettingsProvider>(context).getTheme().primaryBgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: generateDrawer(context),
        ),
      ),
      body: widget.body,
    );
  }
}
