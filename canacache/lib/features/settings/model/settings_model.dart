import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:canacache/features/theming/models/cana_palette_model.dart";

class SettingsModel {
  // Set up all settings defaults
  CanaTheme selectedTheme = CanaPalette.initCanaTheme(CanaPalette.defaultTheme);

  Unit selectedUnit = Unit(unit: DistanceUnit.defaultUnit);

  //db info
  static DBTable table = DBSchema.tables["settings"]!;

  SettingsModel();

  SettingsModel.fromMap(Map<String, dynamic> map) {
    selectedTheme = CanaPalette.initCanaTheme(map["selectedTheme"]);
    selectedUnit = Unit(unit: map["selectedDistanceUnit"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedTheme": selectedTheme.toString(),
      "selectedDistanceUnit": selectedUnit.distanceUnit.name,
      "id": 0
    };
  }

  setSelectedTheme(String key) {
    selectedTheme = CanaPalette.getCanaTheme(key);
  }

  setSelectedDistanceUnit(DistanceUnit unit) {
    selectedUnit.distanceUnit = unit;
  }

  writeSettings() async {
    await DBOperations.insertToDB(table, toMap());
  }

  static Future<SettingsModel> initFromDB() async {
    /*
      This is pretty nasty, and should be re written, needs to revert to default value if 
      no entry is found in the db
    */
    List rows = await DBOperations.getDBTable(table.tableTitle);
    Map<String, dynamic> defaults = {
      "selectedDistanceUnit": DistanceUnit.defaultUnit,
      "selectedTheme": CanaPalette.defaultTheme
    };

    Map<String, dynamic> startMap = {};

    // need to verify results exist
    // then need to make sure all expected columns are present
    if (rows.isNotEmpty && table.verifyMapRow(rows[0])) {
      startMap["selectedDistanceUnit"] =
          DistanceUnit.fromString(rows[0]["selectedDistanceUnit"]) ??
              DistanceUnit.defaultUnit;
      startMap["selectedTheme"] = rows[0]["selectedTheme"];
    } else {
      startMap = defaults;
    }

    return SettingsModel.fromMap(startMap);
  }
}
