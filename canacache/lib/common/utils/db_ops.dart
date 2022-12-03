import "package:canacache/common/utils/db_schema.dart";
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";

const dbFilename = "canacache.db";

Future<Database> init() async {
  //partially taken from in lecture
  var db = openDatabase(
    path.join(await getDatabasesPath(), dbFilename),
    onCreate: (db, version) {
      for (final table in DBTable.values) {
        db.execute("CREATE TABLE ${table.createTableString()}");
      }
    },
    version: 2,
  );

  return db;
}

Future<int> insertToDB(
  DBTable table,
  Map<String, Object?> data, {
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
}) async {
  final db = await init();

  return db.insert(
    table.tableTitle,
    data,
    conflictAlgorithm: conflictAlgorithm,
  );
}

Future<List<Map<String, Object?>>> getDBTable(String table) async {
  final db = await init();

  return await db.query(table);
}
