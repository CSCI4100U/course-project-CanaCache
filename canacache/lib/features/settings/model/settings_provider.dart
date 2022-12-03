import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/settings_model.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:flutter/widgets.dart";

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

  Unit get unit => _currentSettings.selectedUnit;

  CanaTheme get theme => _currentSettings.selectedTheme;

  SettingsModel get currentSettings => _currentSettings;
}
