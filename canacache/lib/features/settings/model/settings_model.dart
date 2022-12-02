import "dart:convert";
import "dart:io";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:path_provider/path_provider.dart";

class SettingsModel {
  // Set up all settings defaults
  CanaTheme selectedTheme = CanaPalette.initCanaTheme(CanaPalette.defaultTheme);

  Unit selectedUnit = Unit(unit: DistanceUnit.defaultUnit);

  static String fileName = "settings.json";
  SettingsModel();

  SettingsModel.fromJson(Map<String, dynamic> map) {
    selectedTheme = CanaPalette.initCanaTheme(map["selectedTheme"]);
    selectedUnit =
        Unit(unit: DistanceUnit.fromString(map["selectedDistanceUnit"]));
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedTheme": selectedTheme.toString(),
      "selectedDistanceUnit": selectedUnit.distanceUnit.name
    };
  }

  writeSettings() async {
    File file =
        File("${(await getExternalStorageDirectory())!.path}/$fileName");
    file.writeAsStringSync(jsonEncode(toMap()));
    //await DBOperations.insertToDB(table, toMap());
  }

  static Future<SettingsModel> initFromJson() async {
    File file =
        File("${(await getExternalStorageDirectory())!.path}/$fileName");

    if (!file.existsSync()) {
      file.createSync();
      await SettingsModel().writeSettings();
    }

    return SettingsModel.fromJson(
      jsonDecode(file.readAsStringSync()),
    );
  }
}
