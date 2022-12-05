import "dart:math";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import 'package:flutter/foundation.dart';
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

    return InkWell(
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                iconData,
                color: selectedTheme.secIconColor,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: selectedTheme.primaryTextColor,
                  fontFamily: selectedTheme.primaryFontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
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
          route: CanaRoute.statsTime,
        ),
        divider,
        const NavItem(
          label: "Distance Traveled",
          iconData: Icons.speed,
          route: CanaRoute.statsDistance,
        ),
        divider,
      ],
    );
    if (kDebugMode) {
      buttons.addAll([
        NavItem(
          label: "Dummy Data (Will populate db with dummy data)",
          iconData: Icons.recycling,
          callback: () => generatePlaceHolderData(context),
        ),
        divider,
        NavItem(
          label: "Delete Stats",
          iconData: Icons.dangerous,
          callback: () => clearData(context),
        ),
      ]);
    }
    return buttons;
  }

  clearData(BuildContext context) async {
    SnackBar snack = errorCanaSnackBar(context, "Cleared Data");
    var db = await initDB();
    await db.delete(dbTables[LocalDBTables.steps]!.tableTitle);
    await db.delete(dbTables[LocalDBTables.mins]!.tableTitle);
    await db.delete(dbTables[LocalDBTables.distance]!.tableTitle);

    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  writeJunkToDB(LocalDBTables table, List<Object> args) async {
    var db = await initDB();
    String dbString =
        """INSERT INTO ${dbTables[table]!.tableTitle} (timeSlice, ${dbTables[table]!.statColumn})
            VALUES(?,?)
            ON CONFLICT(timeSlice)
            DO UPDATE SET ${dbTables[table]!.statColumn} = ?;""";

    await db.execute(dbString, args);
  }

  generatePlaceHolderData(BuildContext context) async {
    SnackBar snack =
        successCanaSnackBar(context, "Added 1000 samples to every stat table");
    // this function is just for debug/testing
    // not very well written

    DateTime trueNow = DateTime.now();

    // generate random for year
    var randomDate = RandomDate.withRange(trueNow.year - 1, trueNow.year + 1);

    for (int i = 0; i < 970; i++) {
      DateTime now = randomDate.random();

      int dSteps = Random().nextInt(10000);
      int numMins = Random().nextInt(60);
      int distance = Random().nextInt(10000);

      DateTime currentHour = DateTime(
        now.year,
        now.month,
        now.day,
        Random().nextInt(24),
      );

      if (currentHour.isAfter(trueNow)) {
        // have gotten hour too far into day
        i -= 1;
        continue;
      }

      List<Object> args1 = [currentHour.toString(), numMins, numMins];
      List<Object> args2 = [currentHour.toString(), dSteps, dSteps];
      List<Object> args3 = [currentHour.toString(), distance, distance];

      await writeJunkToDB(LocalDBTables.mins, args1);
      await writeJunkToDB(LocalDBTables.steps, args2);
      await writeJunkToDB(LocalDBTables.distance, args3);
    }

    // do some for today
    for (int i = 0; i < 30; i++) {
      DateTime currentHour = DateTime(
        trueNow.year,
        trueNow.month,
        trueNow.day - 1,
        Random().nextInt(24),
      );

      if (currentHour.isAfter(trueNow)) {
        // have gotten hour too far into day
        i -= 1;
        continue;
      }

      int dSteps = Random().nextInt(10000);
      int numMins = Random().nextInt(60);
      int distance = Random().nextInt(10000);

      List<Object> args1 = [currentHour.toString(), numMins, numMins];
      List<Object> args2 = [currentHour.toString(), dSteps, dSteps];
      List<Object> args3 = [currentHour.toString(), distance, distance];

      await writeJunkToDB(LocalDBTables.mins, args1);
      await writeJunkToDB(LocalDBTables.steps, args2);
      await writeJunkToDB(LocalDBTables.distance, args3);
    }

    ScaffoldMessenger.of(context).showSnackBar(snack);
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
