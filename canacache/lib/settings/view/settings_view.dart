import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:canacache/common_widgets/cana_scaffold.dart";
import "package:settings_ui/settings_ui.dart";
import "package:canacache/theming/models/cana_palette_model.dart";
import "package:canacache/common_widgets/cana_snackbar.dart";
import "package:canacache/settings/model/settings_provider.dart";
import "package:firebase_auth/firebase_auth.dart";

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SettingsPageView> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPageView> {
  Column generateThemePicker(BuildContext context) {
    List<Widget> content = [];
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).getTheme();

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
                  "Changing Theme to ${k}",
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

  showThemePicker(BuildContext context) async {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).getTheme();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: selectedTheme.primaryBgColor,
        title: Text(
          "Pick A Theme",
          style: TextStyle(
            color: selectedTheme.primaryTextColor,
          ),
        ),
        content: Container(child: generateThemePicker(context)),
      ),
    );
  }

  List<AbstractSettingsSection> generateSettingSections(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).getTheme();

    List<AbstractSettingsSection> sections = [];

    sections.add(
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
              "Theme Secetion",
              style: TextStyle(color: selectedTheme.primaryTextColor),
            ),
            value: Text(
              selectedTheme.themeName,
              style: TextStyle(color: selectedTheme.primaryTextColor),
            ),
            onPressed: (value) => showThemePicker(context),
          ),
        ],
      ),
    );
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
