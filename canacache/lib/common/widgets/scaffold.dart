import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/widgets/appbar.dart";
import "package:canacache/common/widgets/appbar_list_item.dart";
import "package:canacache/features/auth/model/auth.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:http/http.dart" as http;
import "dart:convert";
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
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    children.add(
      SizedBox(
        height: 150,
        child: DrawerHeader(
          decoration: BoxDecoration(
            color: theme.primaryBgColor,
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
          iconData: Icons.location_on,
          label: "Caches",
          route: CanaRoute.caches,
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

  Widget generateWeather(BuildContext context) {
    // refer to https://open-meteo.com/en/docs#latitude=43.94&longitude=-78.89&hourly=temperature_2m,weathercode&daily=weathercode&timeformat=unixtime&timezone=America%2FNew_York
    // for information on how to use the this api

    String requestString =
        "https://api.open-meteo.com/v1/forecast?latitude=43.94&longitude=-78.89&hourly=temperature_2m,weathercode&daily=weathercode&timeformat=unixtime&timezone=America%2FNew_York";
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    return FutureBuilder<http.Response>(
      future: http.get(Uri.parse(requestString)),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = jsonDecode(snapshot.data!.body);
          int latestWeatherCode = data["hourly"]["weathercode"].last;
          double latestTemp = data["hourly"]["temperature_2m"].last;

          IconData weatherIcon = Icons.sunny;
          if ([1, 2, 3, 45, 48].contains(latestWeatherCode)) {
            weatherIcon = Icons.foggy;
          } else if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]
              .contains(latestWeatherCode)) {
            weatherIcon = Icons.water_drop;
          } else if ([71, 73, 75, 77, 95, 96, 99, 85, 86]
              .contains(latestWeatherCode)) {
            weatherIcon = Icons.snowing;
          }

          return Column(
            children: [
              Icon(weatherIcon, color: theme.secIconColor),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "$latestTemp C",
                  style: TextStyle(
                    color: theme.primaryTextColor,
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox(height: 100);
        }
      },
    );

    /*
        ,)

            */
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: generateDrawer(context),
              ),
            ),
            generateWeather(context),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
