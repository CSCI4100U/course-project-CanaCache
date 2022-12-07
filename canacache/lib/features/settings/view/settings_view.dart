import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/widgets/picker.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:canacache/features/settings/view/locale_picker.dart";
import "package:canacache/features/settings/view/theme_picker_content.dart";
import "package:canacache/features/settings/view/unit_picker_content.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<SettingsPageView> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPageView> {
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
    AppLocale selectedLocale = Provider.of<SettingsProvider>(context).language;

    List<AbstractSettingsSection> sections = [];

    sections.addAll([
      SettingsSection(
        title: Text(
          translate("settings.theme.title"),
          style: TextStyle(color: selectedTheme.primaryTextColor),
        ),
        tiles: [
          generateSettingsTile(
            context,
            translate(selectedTheme.nameKey),
            translate("settings.theme.colour.title"),
            () => canaShowDialog(
              context,
              const ThemePickerContent(),
              translate("settings.theme.colour.subtitle"),
            ),
            Icons.format_paint,
          ),
        ],
      ),
      SettingsSection(
        title: Text(
          translate("settings.units.title"),
          style: TextStyle(color: selectedTheme.primaryTextColor),
        ),
        tiles: [
          generateSettingsTile(
            context,
            translate(selectedUnit.distanceUnit.nameKey),
            translate("settings.units.distance.title"),
            () => canaShowDialog(
              context,
              const UnitPickerContent(),
              translate("settings.units.distance.subtitle"),
            ),
            Icons.speed,
          )
        ],
      ),
      SettingsSection(
        title: Text(
          translate("settings.locale.title"),
          style: TextStyle(color: selectedTheme.primaryTextColor),
        ),
        tiles: [
          generateSettingsTile(
            context,
            translate(selectedLocale.nameKey),
            translate("settings.locale.language.title"),
            () => canaShowDialog(
              context,
              const LocalePickerContent(),
              translate("settings.locale.language.subtitle"),
            ),
            Icons.translate,
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
      title: translate("settings.title"),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: selectedTheme.secBgColor,
        ),
        sections: generateSettingSections(context),
      ),
    );
  }
}
