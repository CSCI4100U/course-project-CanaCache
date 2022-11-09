import "package:sqflite/sqflite.dart";
import "package:path/path.dart" as path;

class DBOperations {
  static String dbName = "cannacache.db";

  //<Table Name, Schema>
  static Map<String, String> tables = {
    "settings": "selectedTheme TEXT, selectedUnit TEXT, id PRIMARY KEY"
  };

  static Future init() async {
    //partially taken from in lecture
    var db = openDatabase(
      path.join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        tables.forEach((key, value) {
          db.execute(
            "CREATE TABLE $key($value)",
          );
        });
      },
      version: 1,
    );

    return db;
  }

  static bool isValidTable(String table) {
    return tables.containsKey(table);
  }

  static Future insertToDB(String table, Map data) async {
    if (!isValidTable(table)) {
      throw Exception("Invalid Table Passed");
    }
    print("data insert functio $data");
    final db = await DBOperations.init();
    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List> getDBTable(String table) async {
    if (!isValidTable(table)) {
      throw Exception("Invalid Table Passed");
    }

    final db = await DBOperations.init();

    return await db.query(table);
  }
}
