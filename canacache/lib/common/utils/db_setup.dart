import "package:canacache/common/utils/db_schema.dart";
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";

String dbName = "canacache.db";

Future initDB() async {
  //partially taken from in lecture
  var db = openDatabase(
    path.join(await getDatabasesPath(), dbName),
    onCreate: (db, version) {
      dbTables.forEach((LocalDBTables tableName, DBTable table) {
        print("creating table $tableName");
        db.execute(
          "CREATE TABLE ${table.createTableString()}",
        );
      });
    },
    version: 1,
  );

  return db;
}

Future insertToDB(
  DBTable table,
  Map data, {
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
}) async {
  final db = await initDB();
  return db.insert(
    table.tableTitle,
    data,
    conflictAlgorithm: conflictAlgorithm,
  );
}

Future<List> getDBTable(String table) async {
  final db = await initDB();

  return await db.query(table);
}