import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:canacache/features/theming/models/cana_palette_model.dart";

class SettingsModel {
  // Set up all settings defaults
  CanaTheme _selectedTheme =
      CanaPalette.initCanaTheme(CanaPalette.defaultTheme);

  Unit _selectedUnit = Unit.initUnit(Unit.defaultUnit);

  //db info
  static DBTable table = DBSchema.tables["settings"]!;

  SettingsModel();

  SettingsModel.fromMap(Map<String, dynamic> map) {
    _selectedTheme = CanaPalette.initCanaTheme(map["selectedTheme"]);
    _selectedUnit = Unit.initUnit(map["selectedDistanceUnit"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedTheme": selectedTheme.toString(),
      "selectedDistanceUnit": selectedUnit.distanceUnit.name,
      "id": 0
    };
  }

  CanaTheme get selectedTheme => _selectedTheme;
  Unit get selectedUnit => _selectedUnit;

  set selectedTheme(CanaTheme theme) {
    _selectedTheme = theme;
  }

  set selectedUnit(Unit unit) {
    _selectedUnit = unit;
  }

  setSelectedTheme(String key) {
    _selectedTheme = CanaPalette.getCanaTheme(key);
  }

  setSelectedDistanceUnit(DistanceUnit unit) {
    _selectedUnit.distanceUnit = unit;
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
      "selectedDistanceUnit": Unit.defaultUnit,
      "selectedTheme": CanaPalette.defaultTheme
    };

    Map<String, dynamic> startMap = {};

    // need to verify results exist
    // then need to make sure all expected columns are present
    if (rows.isNotEmpty && table.verifyMapRow(rows[0])) {
      startMap["selectedDistanceUnit"] =
          DistanceUnit.fromString(rows[0]["selectedDistanceUnit"]) ??
              Unit.defaultUnit;
      startMap["selectedTheme"] = rows[0]["selectedTheme"];
    }

    return SettingsModel.fromMap(startMap);
  }
}
