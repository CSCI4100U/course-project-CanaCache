import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";
import "package:fl_chart/fl_chart.dart";

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
        return DateTime(now.year, now.month, now.day - 2, now.hour);
      case week:
        return DateTime(now.year, now.month, now.day - 7, now.hour);
      case month:
        return DateTime(now.year, now.month - 1, now.day, now.hour);
      case year:
        return DateTime(now.year - 1, now.month, now.day, now.hour);
    }
  }
}

class FLChartReqInfo {
  double maxX = 0;
  double minX = 0;
  double maxY = 0;
  List<Map<String, dynamic>> rawData;
  Map<DateTime, dynamic> parsedData = {};
  Map<int, String> bottomAxisLabels = {};

  List<FlSpot> spots = [];

  DateState state;

  generateDayLogic() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, now.hour)
        .subtract(const Duration(days: 1));

    int hoursIntoDay = date.hour;

    minX = -(24 - hoursIntoDay.toDouble());
    maxX = hoursIntoDay.toDouble() - 1;

    // loop through last 24 hours
    for (int i = 0; i < 24; i++) {
      double stepCount = 0;

      double correction = minX - now.hour;

      if (DateTime(now.year, now.month, now.day) ==
          DateTime(date.year, date.month, date.day)) {
        correction = 0;
      }

      if (parsedData.containsKey(date)) {
        stepCount = parsedData[date].toDouble();
      }

      bottomAxisLabels[date.hour + correction.toInt()] = date.hour.toString();

      spots.add(
        FlSpot(
          date.hour.toDouble() + correction,
          stepCount,
        ),
      );

      date = date.add(const Duration(hours: 1));
    }
  }

  FLChartReqInfo({required this.rawData, required this.state}) {
    for (int i = 0; i < rawData.length; i++) {
      // find maxX
      int steps = rawData[i]["steps"]!;
      if (steps > maxY) {
        maxY = steps.toDouble();
      }

      DateTime parsedTime = DateTime.parse(rawData[i]["timeSlice"]!);

      parsedData[parsedTime] = rawData[i]["steps"];
    }

    switch (state) {
      case DateState.day:
        generateDayLogic();
    }
  }
}

enum GraphState { chart, table }

class StatStateModel {
  late List<bool> dateStateSelections;

  DateState dateState = DateState.day;
  GraphState graphState = GraphState.chart;
  LocalDBTables table;
  FLChartReqInfo plotInfo = FLChartReqInfo(rawData: [], state: DateState.day);
  //List<Object> tableData = [];

  StatStateModel({required this.table}) {
    resetDateSelections();
    dateStateSelections[DateState.enumToIndex(dateState)] = true;
  }

  Future<List<Map<String, dynamic>>> readDBData() async {
    //DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    DateTime date = DateState.dateTimeMap(dateState);
    var db = await initDB();
    String query =
        """SELECT * FROM ${dbTables[table]!.tableTitle} WHERE DATE(timeSlice) >= ?""";
    List<Object> args = [date.toString()];

    return await db.rawQuery(query, args);
    /*
    
    */
  }

  setDateState(int index) async {
    if (DateState.isValidIndex(index)) {
      resetDateSelections();
      dateStateSelections[index] = true;
      dateState = DateState.indexToEnum(index)!;
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
