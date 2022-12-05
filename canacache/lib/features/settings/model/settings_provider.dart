import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/settings_model.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:flutter/widgets.dart";
import "package:flutter_translate/flutter_translate.dart";

class SettingsProvider with ChangeNotifier {
  SettingsModel _currentSettings = SettingsModel();

  SettingsProvider() {
    SettingsModel.initFromJson().then((SettingsModel settings) {
      _currentSettings = settings;
      _currentSettings.writeSettings();
      notifyListeners();
    });
  }

  set currentSettings(SettingsModel settings) {
    _currentSettings = settings;
    _currentSettings.writeSettings();
    notifyListeners();
  }

  set theme(CanaTheme theme) {
    _currentSettings.selectedTheme = theme;
    _currentSettings.writeSettings();
    notifyListeners();
  }

  set unit(Unit unit) {
    _currentSettings.selectedUnit = unit;
    _currentSettings.writeSettings();
    notifyListeners();
  }

  // have to pass in context here to be able to
  // change the language of the entire app
  void setLanguage(BuildContext context, AppLocale language) {
    _currentSettings.selectedLanguage = language;
    _currentSettings.writeSettings();
    changeLocale(context, language.languageCode);
    notifyListeners();
  }

  Unit get unit => _currentSettings.selectedUnit;

  CanaTheme get theme => _currentSettings.selectedTheme;

  AppLocale get language => _currentSettings.selectedLanguage;

  SettingsModel get currentSettings => _currentSettings;
}
