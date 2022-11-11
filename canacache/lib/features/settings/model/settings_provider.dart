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

  Unit getUnit() => _currentSettings.selectedUnit;

  CanaTheme getTheme() => _currentSettings.selectedTheme;

  SettingsModel get currentSettings => _currentSettings;
}
