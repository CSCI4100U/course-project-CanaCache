enum LocalDBTables { steps }

Map<LocalDBTables, DBTable> dbTables = {
  LocalDBTables.steps: DBTable(
    tableTitle: "steps",
    columnTypeMap: {"timeSlice": "TEXT", "steps": "INT"},
  ),
};

class DBTable {
  String tableTitle;

  /// <column name, type>
  Map<String, String> columnTypeMap;
  DBTable({required this.tableTitle, required this.columnTypeMap});

  String createTableString() {
    String schema =
        columnTypeMap.entries.map((e) => "${e.key} ${e.value}").join(", ");

    return "$tableTitle($schema)";
  }

  // makes sure that a map contains all the columns
  bool verifyMapRow(Map<String, dynamic> map) {
    for (String colName in columnTypeMap.keys) {
      if (!map.containsKey(colName)) {
        return false;
      }
    }

    return true;
  }
}
