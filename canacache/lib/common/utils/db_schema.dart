enum DBTable {
  settings("settings", {
    "selectedTheme": "TEXT",
    "selectedDistanceUnit": "TEXT",
    "id": "PRIMARY KEY"
  });

  final String tableTitle;

  /// <column name, type>
  final Map<String, String> columnTypeMap;

  const DBTable(this.tableTitle, this.columnTypeMap);

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
