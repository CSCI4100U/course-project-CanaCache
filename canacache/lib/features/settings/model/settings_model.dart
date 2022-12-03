import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/db_ops.dart" as db_ops;
import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/features/settings/model/units.dart";

class SettingsModel {
  // Set up all settings defaults
  CanaTheme selectedTheme = CanaTheme.defaultTheme;
  Unit selectedUnit = Unit(distanceUnit: DistanceUnit.defaultUnit);

  //db info
  static const table = DBTable.settings;

  SettingsModel();

  SettingsModel.fromMap(Map<String, dynamic> map) {
    selectedTheme = CanaTheme.values.byName(map["selectedTheme"]);
    selectedUnit = Unit(
      distanceUnit: DistanceUnit.values.byName(map["selectedDistanceUnit"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedTheme": selectedTheme.name,
      "selectedDistanceUnit": selectedUnit.distanceUnit.name,
      "id": 0
    };
  }

  writeSettings() async {
    await db_ops.insertToDB(table, toMap());
  }

  static Future<SettingsModel> initFromDB() async {
    /*
      This is pretty nasty, and should be re written, needs to revert to default value if 
      no entry is found in the db
    */
    List rows = await db_ops.getDBTable(table.tableTitle);
    Map<String, String> defaults = {
      "selectedDistanceUnit": DistanceUnit.defaultUnit.name,
      "selectedTheme": CanaTheme.defaultTheme.name
    };

    Map<String, String> startMap = {};

    // need to verify results exist
    // then need to make sure all expected columns are present
    if (rows.isNotEmpty && table.verifyMapRow(rows[0])) {
      startMap["selectedDistanceUnit"] = rows[0]["selectedDistanceUnit"];
      startMap["selectedTheme"] = rows[0]["selectedTheme"];
    } else {
      startMap = defaults;
    }

    return SettingsModel.fromMap(startMap);
  }
}
