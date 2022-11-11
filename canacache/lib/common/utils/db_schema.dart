class DBSchema {
  static final Map<String, DBTable> tables = {
    "settings": DBTable(
      tableTitle: "settings",
      columnTypeMap: {
        "selectedTheme": "TEXT",
        "selectedDistanceUnit": "TEXT",
        "id": "PRIMARY KEY"
      },
    ),
  };
}

class DBTable {
  String tableTitle;
  // <column name, type>
  Map<String, String> columnTypeMap;
  DBTable({required this.tableTitle, required this.columnTypeMap});

  String createTableString() {
    String schema = "";

    columnTypeMap.forEach((colName, type) {
      schema += "$colName $type, ";
    });

    // need to get rid of last comma and space
    schema = schema.substring(0, schema.length - 2);
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
