import "dart:convert";
import "dart:io";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:path_provider/path_provider.dart";

class SettingsModel {
  // Set up all settings defaults
  CanaTheme selectedTheme = CanaTheme.defaultTheme;
  Unit selectedUnit = Unit(
    distanceUnit: DistanceUnit.defaultUnit,
  );
  AppLocale selectedLanguage = AppLocale.defaultLocale;

  static const fileName = "settings.json";

  SettingsModel();

  SettingsModel.fromJson(Map<String, dynamic> map)
      : selectedTheme = CanaTheme.values.byName(map["selectedTheme"]),
        selectedUnit = Unit(
          distanceUnit: DistanceUnit.values.byName(map["selectedDistanceUnit"]),
        ),
        selectedLanguage = AppLocale.values.byName(map["selectedLanguage"]);

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
