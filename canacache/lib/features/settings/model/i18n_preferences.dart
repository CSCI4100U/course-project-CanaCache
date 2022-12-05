import "dart:ui";

import "package:canacache/features/settings/model/settings_model.dart";
import "package:flutter_translate/flutter_translate.dart";

// TODO: should we have SettingsModel implement ITranslatePreferences instead?
// https://github.com/Jesway/Flutter-Translate/wiki/2.-Automatically-saving-&-restoring-the-selected-locale
class TranslatePreferences implements ITranslatePreferences {
  @override
  Future<Locale?> getPreferredLocale() {
    return SettingsModel.initFromJson().then(
      (settings) => localeFromString(settings.selectedLanguage.languageCode),
    );
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    // await SettingsModel.initFromJson().then((settings) {
    //   settings.selectedLanguage = AppLocale.values
    //       .firstWhere((l) => l.languageCode == locale.languageCode);
    // });
  }
}
