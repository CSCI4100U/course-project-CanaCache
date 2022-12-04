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
        return DateTime(now.year, now.month, now.day - 1, now.hour);
      case week:
        return DateTime(now.year, now.month, now.day - 7, now.hour);
      case month:
        return DateTime(now.year, now.month - 1, now.day, now.hour);
      case year:
        return DateTime(now.year - 1, now.month, now.day, now.hour);
    }
  }

  static double maxXLookup(DateState state) {
    switch (state) {
      case day:
        return 24;
      case week:
        return 7;
      case month:
        return 30;
      case year:
        return 12;
    }
  }
}

class FLChartReqInfo {
  double maxX = 0;
  double maxY = 0;
  List<double> chartX = [];
  List<double> chartY = [];
  List<Map<String, dynamic>> rawData;
  Map<DateTime, dynamic> parsedData = {};

  List<DateTime> dates = [];
  List<FlSpot> spots = [];

  DateState state;

  FLChartReqInfo({required this.rawData, required this.state}) {
    maxX = DateState.maxXLookup(state);

    for (int i = 0; i < rawData.length; i++) {
      // find maxX
      int steps = rawData[i]["steps"]!;
      if (steps > maxY) {
        maxY = steps.toDouble();
      }
      // parse to DateTime so eaiser to work with
      DateTime parsedTime = DateTime.parse(rawData[i]["timeSlice"]!);
      //print("${steps / 100}, ${parsedTime}");

      parsedData[parsedTime] = rawData[i]["steps"];
      dates.add(parsedTime);
    }

    dates.sort((a, b) => a.compareTo(b));
    if (state == DateState.day) {
      for (DateTime date in dates) {
        spots.add(
          FlSpot(
            date.hour.toDouble(),
            parsedData[date].toDouble(),
          ),
        );
      }
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

  readDBData() async {
    //DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    DateTime date = DateState.dateTimeMap(dateState);
    var db = await initDB();
    String query =
        """SELECT * FROM ${dbTables[table]!.tableTitle} WHERE DATE(timeSlice) >= ?""";
    List<Object> args = [date.toString()];

    print(await db.rawQuery(query, args));
    plotInfo = FLChartReqInfo(
      rawData: await db.rawQuery(query, args),
      state: dateState,
    );
  }

  setDateState(int index) async {
    if (DateState.isValidIndex(index)) {
      resetDateSelections();
      dateStateSelections[index] = true;
      dateState = DateState.indexToEnum(index)!;
      await readDBData();
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
