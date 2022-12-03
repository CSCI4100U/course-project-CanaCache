import "dart:convert";
import "dart:io";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:path_provider/path_provider.dart";

class SettingsModel {
  // Set up all settings defaults
  CanaTheme selectedTheme = CanaTheme.defaultTheme;
  Unit selectedUnit = Unit(distanceUnit: DistanceUnit.defaultUnit);

  static String fileName = "settings.json";
  SettingsModel();

  SettingsModel.fromJson(Map<String, dynamic> map) {
    selectedTheme = CanaTheme.values.byName(map["selectedTheme"]);
    selectedUnit = Unit(
      distanceUnit: DistanceUnit.values.byName(map["selectedDistanceUnit"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedTheme": selectedTheme.name,
      "selectedDistanceUnit": selectedUnit.distanceUnit.name,
    };
  }

  Future<void> writeSettings() async {
    File file =
        File("${(await getExternalStorageDirectory())!.path}/$fileName");
    file.writeAsStringSync(jsonEncode(toMap()));
    //await DBOperations.insertToDB(table, toMap());
  }

  static Future<SettingsModel> initFromJson() async {
    final externalStorageDirectory = await getExternalStorageDirectory();
    File file = File("${externalStorageDirectory!.path}/$fileName");

    if (!file.existsSync()) {
      file.createSync();
      await SettingsModel().writeSettings();
    }

    return SettingsModel.fromJson(
      jsonDecode(file.readAsStringSync()),
    );
  }
}
