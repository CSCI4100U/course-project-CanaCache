import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:canacache/common_widgets/cana_scaffold.dart";
import "package:settings_ui/settings_ui.dart";
import "package:canacache/theming/models/cana_palette_model.dart";
import "package:canacache/common_widgets/cana_snackbar.dart";
import "package:canacache/settings/model/settings_provider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:canacache/settings/model/units.dart";
import "package:canacache/common_widgets/cana_picker.dart";

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

    Unit.validUnits.forEach((String k, _) {
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
                  "Changing Unit to $currentUnit",
                ),
              );
            },
            child: Container(
              color: currentUnit == providedUnit
                  ? selectedTheme.secBgColor
                  : selectedTheme.primaryBgColor,
              child: Center(
                child: Text(
                  currentUnit.toString(),
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
        tiles: <SettingsTile>[
          SettingsTile.navigation(
            leading:
                Icon(Icons.format_paint, color: selectedTheme.primaryIconColor),
            title: Text(
              "Theme Selection",
              style: TextStyle(color: selectedTheme.primaryTextColor),
            ),
            value: Text(
              selectedTheme.toString(),
              style: TextStyle(color: selectedTheme.primaryTextColor),
            ),
            onPressed: (value) => CanaPicker.canaShowDialog(
              context,
              generateThemePickerContent(context),
              "Pick a Theme",
            ),
          ),
        ],
      ),
      SettingsSection(
        title: Text(
          "Units",
          style: TextStyle(color: selectedTheme.primaryTextColor),
        ),
        tiles: <SettingsTile>[
          SettingsTile.navigation(
            leading: Icon(Icons.speed, color: selectedTheme.primaryIconColor),
            title: Text("Distance",
                style: TextStyle(color: selectedTheme.primaryTextColor)),
            value: Text(
              selectedUnit.toString(),
              style: TextStyle(color: selectedTheme.primaryTextColor),
            ),
            onPressed: (value) => CanaPicker.canaShowDialog(
              context,
              generateUnitPickerContent(context),
              "Pick Unit",
            ),
          ),
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
