import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/common/widgets/picker.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:canacache/features/theming/models/cana_palette_model.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SettingsPageView> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPageView> {
  Column generateUnitPickerContent(BuildContext context) {
    List<Widget> content = [];

    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).getTheme();

    Unit providedUnit =
        Provider.of<SettingsProvider>(context, listen: false).getUnit();

    for (DistanceUnit k in DistanceUnit.values) {
      Unit currentUnit = Unit(unit: k);
      content.add(
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: InkWell(
            onTap: () {
              Provider.of<SettingsProvider>(context, listen: false)
                  .setUnit(currentUnit);

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                successCanaSnackBar(
                  context,
                  "Changing Distance Unit to ${currentUnit.distanceUnit}",
                ),
              );
            },
            child: Container(
              color: currentUnit.distanceUnit == providedUnit.distanceUnit
                  ? selectedTheme.secBgColor
                  : selectedTheme.primaryBgColor,
              child: Center(
                child: Text(
                  currentUnit.distanceUnit.toString(),
                  style: TextStyle(
                    color: selectedTheme.primaryTextColor,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(children: content);
  }

  Column generateThemePickerContent(BuildContext context) {
    List<Widget> content = [];
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).getTheme();

    CanaPalette.cannaThemes.forEach((String k, CanaTheme value) {
      content.add(
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: InkWell(
            onTap: () {
              Provider.of<SettingsProvider>(context, listen: false)
                  .setTheme(value);

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                successCanaSnackBar(
                  context,
                  "Changing Theme to $k",
                ),
              );
            },
            child: Container(
              color: k == selectedTheme.themeName
                  ? selectedTheme.secBgColor
                  : selectedTheme.primaryBgColor,
              child: Center(
                child: Text(
                  k,
                  style: TextStyle(
                    color: selectedTheme.primaryTextColor,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });

    return Column(children: content);
  }

  SettingsTile generateSettingsTile(
    BuildContext context,
    String tileText,
    String title,
    Function callback,
    IconData icon,
  ) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).getTheme();

    return SettingsTile.navigation(
      leading: Icon(icon, color: selectedTheme.primaryIconColor),
      title: Text(
        title,
        style: TextStyle(color: selectedTheme.primaryTextColor),
      ),
      value: Text(
        tileText,
        style: TextStyle(color: selectedTheme.primaryTextColor),
      ),
      onPressed: (context) => callback(),
    );
  }

  List<AbstractSettingsSection> generateSettingSections(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).getTheme();
    Unit selectedUnit = Provider.of<SettingsProvider>(context).getUnit();

    List<AbstractSettingsSection> sections = [];

    sections.addAll([
      SettingsSection(
        title: Text(
          "Theme",
          style: TextStyle(color: selectedTheme.primaryTextColor),
        ),
        tiles: [
          generateSettingsTile(
            context,
            selectedTheme.toString(),
            "Theme Selection",
            () => CanaPicker.canaShowDialog(
              context,
              generateThemePickerContent(context),
              "Pick a Theme",
            ),
            Icons.format_paint,
          ),
        ],
      ),
      SettingsSection(
        title: Text(
          "Units",
          style: TextStyle(color: selectedTheme.primaryTextColor),
        ),
        tiles: [
          generateSettingsTile(
            context,
            selectedUnit.distanceUnit.toString(),
            "Distance",
            () => CanaPicker.canaShowDialog(
              context,
              generateUnitPickerContent(context),
              "Pick Unit",
            ),
            Icons.speed,
          )
        ],
      ),
    ]);

    // for later if you want settings only logged in users can see
    if (FirebaseAuth.instance.currentUser != null) {}
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).getTheme();

    return CanaScaffold(
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: selectedTheme.secBgColor,
        ),
        sections: generateSettingSections(context),
      ),
      title: widget.title,
    );
  }
}
