import "package:canacache/common/utils/cana_palette_model.dart";
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
  final List<Widget>? navItems;

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
            color: Provider.of<SettingsProvider>(context).theme.primaryBgColor,
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

    if (FirebaseAuth.instance.currentUser != null) {
      children.addAll([
        const CanaAppBarListItem(
          iconData: Icons.home,
          label: "Home",
          route: CanaRoute.home,
        ),
        const CanaAppBarListItem(
          iconData: Icons.multiline_chart,
          label: "Stats",
          route: CanaRoute.stats,
        ),
        const CanaAppBarListItem(
          iconData: Icons.settings_applications,
          label: "Settings",
          route: CanaRoute.settings,
        ),
        const CanaAppBarListItem(
          iconData: Icons.logout,
          label: "Logout",
          route: CanaRoute.logout,
          clearNavigation: true,
          callback: UserAuth.deleteCurrentUser,
        ),
      ]);
    } else {
      children.addAll([
        const CanaAppBarListItem(
          iconData: Icons.settings_applications,
          label: "Settings",
          route: CanaRoute.settings,
        ),
        const CanaAppBarListItem(
          iconData: Icons.account_box,
          label: "Sign In",
          route: CanaRoute.signIn,
          clearNavigation: true,
        )
      ]);
    }

    children.addAll(widget.navItems ?? []);
    return children;
  }

  @override
  Widget build(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    return Scaffold(
      appBar: CanaAppBar(title: widget.title, scaffState: widget._scaffState),
      backgroundColor: theme.secBgColor,
      key: widget._scaffState,
      drawer: Drawer(
        backgroundColor: theme.primaryBgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: generateDrawer(context),
        ),
      ),
      body: widget.body,
    );
  }
}
