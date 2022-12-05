import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/common/widgets/picker.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<SettingsPageView> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPageView> {
  Widget generatePickerItem(
    BuildContext context,
    String snackBarText,
    String itemText,
    bool highlight,
    VoidCallback callback,
  ) {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {
          callback();

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            successCanaSnackBar(
              context,
              snackBarText,
            ),
          );
        },
        child: Container(
          color: highlight
              ? selectedTheme.secBgColor
              : selectedTheme.primaryBgColor,
          child: Center(
            child: Text(
              itemText,
              style: TextStyle(
                color: selectedTheme.primaryTextColor,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column generateUnitPickerContent(BuildContext context) {
    List<Widget> content = [];

    Unit providedUnit =
        Provider.of<SettingsProvider>(context, listen: false).unit;

    for (DistanceUnit k in DistanceUnit.values) {
      Unit currentUnit = Unit(distanceUnit: k);

      content.add(
        generatePickerItem(
          context,
          "Changing Distance Unit to ${currentUnit.distanceUnit}",
          currentUnit.distanceUnit.toString(),
          currentUnit.distanceUnit == providedUnit.distanceUnit,
          () {
            Provider.of<SettingsProvider>(context, listen: false).unit =
                currentUnit;
          },
        ),
      );
    }
    return Column(children: content);
  }

  Column generateThemePickerContent(BuildContext context) {
    /*
BuildContext context,
    String snackBarText,
    String itemText,
    bool highlight,
    VoidCallback callback,

         */
    List<Widget> content = [];
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;

    for (final theme in CanaTheme.values) {
      content.add(
        generatePickerItem(
          context,
          "Changing Theme to ${theme.themeName}",
          theme.themeName,
          theme == selectedTheme,
          () {
            Provider.of<SettingsProvider>(context, listen: false).theme = theme;
          },
        ),
      );
    }

    return Column(children: content);
  }

  SettingsTile generateSettingsTile(
    BuildContext context,
    String tileText,
    String title,
    Function callback,
    IconData icon,
  ) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;

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
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;
    Unit selectedUnit = Provider.of<SettingsProvider>(context).unit;

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
            () => canaShowDialog(
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
            () => canaShowDialog(
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
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;

    return CanaScaffold(
      title: "Settings",
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: selectedTheme.secBgColor,
        ),
        sections: generateSettingSections(context),
      ),
    );
  }
}
