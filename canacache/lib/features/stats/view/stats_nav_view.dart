import "dart:math";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:random_date/random_date.dart";

class NavItem extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final CanaRoute? route;
  final bool clearNavigation;
  final VoidCallback? callback;

  const NavItem({
    super.key,
    this.iconData,
    required this.label,
    this.route,
    this.callback,
    this.clearNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;

    return TextButton.icon(
      icon: Icon(
        iconData,
        color: selectedTheme.secIconColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selectedTheme.primaryTextColor,
          fontFamily: selectedTheme.primaryFontFamily,
        ),
      ),
      onPressed: () {
        if (callback != null) {
          callback!();
        }

        if (route != null) {
          Navigator.pushNamed(context, route!.name);
        }
      },
    );
  }
}

class StatHomeView extends StatelessWidget {
  List<Widget> generateNavButtons(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    List<Widget> buttons = [];
    Divider divider = Divider(
      height: 7,
      thickness: 3,
      indent: 0,
      color: theme.primaryBgColor,
      endIndent: 0,
    );

    buttons.addAll(
      [
        const NavItem(
          label: "Steps Stats",
          iconData: Icons.directions_walk,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const NavItem(
          label: "Time Spent",
          iconData: Icons.hourglass_top,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const NavItem(
          label: "Distance Traveled",
          iconData: Icons.speed,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const NavItem(
          label: "Movement History",
          iconData: Icons.run_circle,
          route: CanaRoute.statsSteps,
        ),
        divider,
        NavItem(
          label: "Dummy Data (Will populate db with dummy data)",
          iconData: Icons.recycling,
          callback: () => generatePlaceHolderData(),
        ),
      ],
    );
    return buttons;
  }

  generatePlaceHolderData() async {
    var db = await initDB();

    DateTime trueNow = DateTime.now();

    // generate random for year
    var randomDate = RandomDate.withRange(trueNow.year - 1, trueNow.year + 1);

    for (int i = 0; i < 1000; i++) {
      DateTime now = randomDate.random();

      int dSteps = Random().nextInt(10000);

      DateTime currentHour = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour + Random().nextInt(13),
      );

      if (trueNow.isBefore(currentHour)) {
        continue;
      }

      List<Object> args = [currentHour.toString(), dSteps, dSteps];
      //print("$currentHour $dSteps");
      String dbString =
          """INSERT INTO ${dbTables[LocalDBTables.steps]!.tableTitle} (timeSlice, steps)
              VALUES(?,?)
              ON CONFLICT(timeSlice)
              DO UPDATE SET steps = steps+?;""";

      await db.execute(dbString, args);
    }

    // generate random for today
    /*
    for (int j = 0; j < 24; j++) {
      DateTime now = DateTime.now();

      int dSteps = Random().nextInt(10000);

      DateTime currentHour = DateTime(
        now.year,
        now.month,
        now.day,
        j,
      );

      List<Object> args = [currentHour.toString(), dSteps, dSteps];
      //print("$currentHour $dSteps");
      String dbString =
          """INSERT INTO ${dbTables[LocalDBTables.steps]!.tableTitle} (timeSlice, steps)
              VALUES(?,?)
              ON CONFLICT(timeSlice)
              DO UPDATE SET steps = steps+?;""";

      await db.execute(dbString, args);
    }
    */
  }

  const StatHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: generateNavButtons(context),
        ),
      ),
    );
  }
}
