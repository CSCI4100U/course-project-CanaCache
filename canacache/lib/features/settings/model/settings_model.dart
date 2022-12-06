import "dart:convert";
import "dart:io";

import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/formatting_extensions.dart";
import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:path_provider/path_provider.dart";

class SettingsModel {
  CanaTheme selectedTheme;
  Unit selectedUnit;
  AppLocale selectedLanguage;

  static const fileName = "settings.json";

  // Set up all settings defaults
  SettingsModel({CanaTheme? theme, Unit? unit, AppLocale? language})
      : selectedTheme = theme ?? CanaTheme.defaultTheme,
        selectedUnit = unit ?? Unit(), // unit defaults are in Unit constructor
        selectedLanguage = language ?? AppLocale.defaultLocale;

  SettingsModel.fromJson(Map<String, dynamic> map)
      : this(
          // Gracefully handle missing settings
          theme: CanaTheme.values.tryByName(map["selectedTheme"]),
          unit: Unit(
            distanceUnit:
                DistanceUnit.values.tryByName(map["selectedDistanceUnit"]),
          ),
          language: AppLocale.values.tryByName(map["selectedLanguage"]),
        );

  Map<String, dynamic> toMap() => {
        "selectedTheme": selectedTheme.name,
        "selectedDistanceUnit": selectedUnit.distanceUnit.name,
        "selectedLanguage": selectedLanguage.name,
      };

  Future<void> writeSettings() async {
    final file = await getFile();
    file.writeAsStringSync(json.encode(toMap()));
  }

  static Future<SettingsModel> initFromJson() async {
    final file = await getFile();

    if (!file.existsSync()) {
      file.createSync();
      await SettingsModel().writeSettings();
    }

    return SettingsModel.fromJson(json.decode(file.readAsStringSync()));
  }

  static Future<File> getFile() async {
    final externalStorageDirectory = await getExternalStorageDirectory();
    final path = "${externalStorageDirectory!.path}/$fileName";
    return File(path);
  }
}
