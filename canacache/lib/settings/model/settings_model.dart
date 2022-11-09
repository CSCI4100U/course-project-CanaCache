import "package:canacache/theming/models/cana_palette_model.dart";
import "package:canacache/settings/model/units.dart";
import "package:canacache/local_database/db_setup.dart";

class SettingsModel {
  CanaTheme _selectedTheme =
      CanaPalette.initCanaTheme(CanaPalette.defaultTheme);
  Unit _selectedUnit = Unit.initUnit(Unit.defaultUnit);

  //db info
  static const tableName = "settings";
  static const columnNames = ["selectedTheme", "selectedUnit"];

  SettingsModel();

  SettingsModel.fromMap(Map<String, dynamic> map) {
    _selectedTheme = CanaPalette.initCanaTheme(map["selectedTheme"] ?? "");
    _selectedUnit = Unit.initUnit(map["selectedUnit"] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedTheme": selectedTheme.toString(),
      "selectedUnit": selectedUnit.toString(),
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

  setSelectedUnit(String key) {
    _selectedUnit.unit = key;
  }

  writeSettings() async {
    await DBOperations.insertToDB(tableName, toMap());
  }

  static Future<SettingsModel> initFromDB() async {
    /*
      This is pretty nasty, and should be re written, needs to revert to default value if 
      no entry is found in the db
    */
    List rows = await DBOperations.getDBTable(tableName);
    Map<String, dynamic> defaults = {
      "setSelectedUnit": "",
      "setSelectedTheme": ""
    };
    Map<String, dynamic> startMap = defaults;

    if (rows.isNotEmpty) {
      startMap = rows[0];
      for (String column in columnNames) {
        if (!rows[0].containsKey(column)) {
          startMap = defaults;
          break;
        }
      }
    }

    return SettingsModel.fromMap(startMap);
  }
}
