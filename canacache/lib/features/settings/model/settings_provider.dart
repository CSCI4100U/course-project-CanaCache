import "package:canacache/features/settings/model/settings_model.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:canacache/features/theming/models/cana_palette_model.dart";
import "package:flutter/widgets.dart";

class SettingsProvider with ChangeNotifier {
  SettingsModel _currentSettings = SettingsModel();

  SettingsProvider() {
    SettingsModel.initFromDB().then((SettingsModel settings) {
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

  CanaTheme getTheme() {
    return _currentSettings.selectedTheme;
  }

  setTheme(CanaTheme theme) {
    _currentSettings.selectedTheme = theme;
    _currentSettings.writeSettings();
    notifyListeners();
  }

  setUnit(Unit unit) {
    _currentSettings.selectedUnit = unit;
    _currentSettings.writeSettings();
    notifyListeners();
  }

  Unit getUnit() {
    return _currentSettings.selectedUnit;
  }

  SettingsModel get currentSettings => _currentSettings;
}
