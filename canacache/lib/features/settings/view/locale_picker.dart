import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/view/picker_item.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";

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
