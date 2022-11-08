import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:canacache/common_widgets/cana_scaffold.dart";
import "package:settings_ui/settings_ui.dart";
import "package:canacache/theming/models/cana_palette_model.dart";
import "package:canacache/theming/models/cana_pallet_provider.dart";
import "package:canacache/common_widgets/cana_snackbar.dart";

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SettingsPageView> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPageView> {
  Column generateThemePicker(BuildContext context) {
    List<Widget> content = [];
    CanaTheme selectedTheme =
        Provider.of<CanaThemeProvider>(context).selectedTheme;

    CanaPalette.cannaThemes.forEach((String k, CanaTheme value) {
      content.add(
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: InkWell(
              onTap: () {
                Provider.of<CanaThemeProvider>(context, listen: false)
                    .selectedTheme = value;

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
            )),
      );
    });

    return Column(children: content);
  }

  showThemePicker(BuildContext context) async {
    CanaTheme selectedTheme =
        Provider.of<CanaThemeProvider>(context, listen: false).selectedTheme;

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

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme =
        Provider.of<CanaThemeProvider>(context).selectedTheme;

    return CanaScaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              "Theme",
              style: TextStyle(color: selectedTheme.primaryTextColor),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading:
                    Icon(Icons.language, color: selectedTheme.primaryIconColor),
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
        ],
      ),
      title: widget.title,
    );
  }
}
