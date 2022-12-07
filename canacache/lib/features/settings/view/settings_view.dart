import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/common/widgets/picker.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/model/units.dart";
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

class PickerItem extends StatelessWidget {
  final String Function() buildSnackBarText;
  final String itemText;
  final bool highlight;
  final Future<void> Function() callback;

  const PickerItem({
    super.key,
    required this.buildSnackBarText,
    required this.itemText,
    required this.highlight,
    required this.callback,
  });

  @override
  Widget build(BuildContext context, {mounted = true}) {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;
    // mounted is always true in StatelessWidget

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () async {
          await callback();
          if (!mounted) {
            return;
          }

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            successCanaSnackBar(context, buildSnackBarText()),
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
}

class UnitPickerContent extends StatelessWidget {
  const UnitPickerContent({super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];

    Unit providedUnit =
        Provider.of<SettingsProvider>(context, listen: false).unit;

    for (DistanceUnit k in DistanceUnit.values) {
      Unit currentUnit = Unit(distanceUnit: k);

      content.add(
        PickerItem(
          buildSnackBarText: () => translate(
            "settings.units.distance.change",
            args: {
              "distance": translate(currentUnit.distanceUnit.nameKey),
            },
          ),
          itemText: translate(k.nameKey),
          highlight: currentUnit.distanceUnit == providedUnit.distanceUnit,
          callback: () async =>
              Provider.of<SettingsProvider>(context, listen: false).unit =
                  currentUnit,
        ),
      );
    }
    return Column(children: content);
  }
}

class ThemePickerContent extends StatelessWidget {
  const ThemePickerContent({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;

    for (final theme in CanaTheme.values) {
      content.add(
        PickerItem(
          buildSnackBarText: () => translate(
            "settings.theme.colour.change",
            args: {"theme": translate(theme.nameKey)},
          ),
          itemText: translate(theme.nameKey),
          highlight: theme == selectedTheme,
          callback: () async =>
              Provider.of<SettingsProvider>(context, listen: false).theme =
                  theme,
        ),
      );
    }

    return Column(children: content);
  }
}

class LocalePickerContent extends StatelessWidget {
  const LocalePickerContent({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];

    AppLocale selectedLanguage =
        Provider.of<SettingsProvider>(context, listen: false).language;

    for (AppLocale locale in AppLocale.values) {
      content.add(
        PickerItem(
          buildSnackBarText: () => translate(
            "settings.locale.language.change",
            args: {
              "locale": translate(locale.nameKey),
            },
          ),
          itemText: translate(locale.nameKey),
          highlight: selectedLanguage.name == locale.name,
          callback: () async =>
              Provider.of<SettingsProvider>(context, listen: false)
                  .setLanguage(context, locale),
        ),
      );
    }
    return Column(children: content);
  }
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
