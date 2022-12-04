import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";

enum DateState {
  day,
  week,
  month,
  year;

  static DateState? indexToEnum(int index) {
    if (isValidIndex(index)) {
      return DateState.values[index];
    }
    return null;
  }

  static bool isValidIndex(int index) {
    return index >= 0 && index < DateState.values.length;
  }

  static int enumToIndex(DateState state) {
    for (int i = 0; i < DateState.values.length; i++) {
      if (DateState.values[i] == state) {
        return i;
      }
    }
    // should never get here
    return 0;
  }

  static DateTime dateTimeMap(DateState state) {
    DateTime now = DateTime.now();

    switch (state) {
      case day:
        return DateTime(now.year, now.month, now.day - 1, now.hour);
      case week:
        return DateTime(now.year, now.month, now.day - 7, now.hour);
      case month:
        return DateTime(now.year, now.month - 1, now.day, now.hour);
      case year:
        return DateTime(now.year - 1, now.month, now.day, now.hour);
    }
  }
}

enum GraphState { chart, table }

class StatStateModel {
  late List<bool> dateStateSelections;

  DateState dateState = DateState.day;
  GraphState graphState = GraphState.chart;
  LocalDBTables table;

  StatStateModel({required this.table}) {
    resetDateSelections();
    dateStateSelections[DateState.enumToIndex(dateState)] = true;
  }

  Future<List<Object>> readDBData() async {
    //DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    DateTime date = DateState.dateTimeMap(dateState);
    var db = await initDB();
    String query =
        """SELECT * FROM ${dbTables[table]!.tableTitle} WHERE DATE(timeSlice) >= ?""";
    List<Object> args = [date.toString()];
    return await db.rawQuery(query, args);
  }

  setDateState(int index) {
    if (DateState.isValidIndex(index)) {
      resetDateSelections();
      dateStateSelections[index] = true;
      dateState = DateState.indexToEnum(index)!;
      readDBData();
    }
  }

  invertGraphState() {
    if (graphState == GraphState.chart) {
      graphState = GraphState.table;
    } else {
      graphState = GraphState.chart;
    }
  }

  resetDateSelections() {
    dateStateSelections = List.generate(DateState.values.length, (_) => false);
  }
}
