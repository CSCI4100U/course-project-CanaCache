enum LocalDBTables { steps, mins, distance }

Map<LocalDBTables, DBTable> dbTables = {
  LocalDBTables.steps: const DBTable(
    tableTitle: "steps",
    columnTypeMap: {"timeSlice": "TEXT UNIQUE", "steps": "INT"},
    statColumn: "steps",
    statName: "Steps",
  ),
  LocalDBTables.mins: const DBTable(
    tableTitle: "mins",
    columnTypeMap: {"timeSlice": "TEXT UNIQUE", "mins": "INT"},
    statColumn: "mins",
    statName: "Mins",
  ),
  LocalDBTables.distance: const DBTable(
    tableTitle: "distance",
    columnTypeMap: {"timeSlice": "TEXT UNIQUE", "distance": "INT"},
    statColumn: "distance",
    statName: "Distance (M)",
  ),
};

class DBTable {
  final String tableTitle;
  final String? statColumn;
  final String? statName;

  /// <column name, type>
  final Map<String, String> columnTypeMap;

  const DBTable({
    required this.tableTitle,
    required this.columnTypeMap,
    this.statColumn,
    this.statName,
  });

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
