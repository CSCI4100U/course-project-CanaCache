import "package:canacache/theming/models/cana_palette_model.dart";
import "package:canacache/settings/model/units.dart";
import "package:canacache/local_database/db_setup.dart";

class SettingsModel {
  CanaTheme _selectedTheme =
      CanaPalette.initCanaTheme(CanaPalette.defaultTheme);
  Unit _selectedUnit = Unit.initUnit(Unit.defaultUnit);

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

  setSelectedTheme(String key) {
    _selectedTheme = CanaPalette.getCanaTheme(key);
  }

  setSelectedUnit(String key) {
    _selectedUnit.unit = key;
  }

  writeSettings() async {
    print("selfewd them ewrite $_selectedTheme");
    await DBOperations.insertToDB(tableName, toMap());
  }

  static Future<SettingsModel> initFromDB() async {
    List rows = await DBOperations.getDBTable(tableName);
    Map<String, dynamic> defaults = {
      "setSelectedUnit": "",
      "setSelectedTheme": ""
    };
    Map<String, dynamic> startMap = defaults;
    for (var row in rows) {
      print("current row $row");
    }
    if (rows.isNotEmpty) {
      startMap = rows[0];
      print("start map $startMap");
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
