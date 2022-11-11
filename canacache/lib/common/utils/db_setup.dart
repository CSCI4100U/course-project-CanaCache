import "package:canacache/common/utils/db_schema.dart";
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";

class DBOperations {
  static String dbName = "cannacache.db";

  static Future init() async {
    //partially taken from in lecture
    var db = openDatabase(
      path.join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        DBSchema.tables.forEach((String tableName, DBTable table) {
          db.execute(
            "CREATE TABLE ${table.createTableString()}",
          );
        });
      },
      version: 2,
    );

    return db;
  }

  static Future insertToDB(DBTable table, Map data) async {
    final db = await DBOperations.init();
    return db.insert(
      table.tableTitle,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List> getDBTable(String table) async {
    final db = await DBOperations.init();

    return await db.query(table);
  }
}
