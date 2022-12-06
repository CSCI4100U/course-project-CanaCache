import "package:canacache/common/utils/db_ops.dart";
import "package:canacache/common/utils/db_schema.dart";
import "package:fl_chart/fl_chart.dart";
import "package:intl/intl.dart";

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
        return DateTime(now.year, now.month, now.day - 6, now.hour);
      case month:
        return DateTime(now.year, now.month - 1, now.day, now.hour);
      case year:
        return DateTime(now.year - 1, now.month + 1, now.day, now.hour);
    }
  }

  static String timePeriodAxisMap(DateState state) {
    switch (state) {
      case day:
        return "Hour";
      case week:
        return "Day";
      case month:
        return "Day";
      case year:
        return "Month";
    }
  }
}

class FLChartReqInfo {
  double maxX = 0;
  double minX = 0;
  double maxY = 0;
  double interval = 1;
  int scale = 1000;
  String prefix = "";
  String bottomAxisLabel = "";
  String leftAxisLabel = "";

  List<Map<String, dynamic>> rawData;
  Map<DateTime, dynamic> parsedData = {};
  Map<int, String> bottomAxisLabels = {};

  DBTable table;
  List<FlSpot> spots = [];
  DateState state;

  String getLeftWidgetText(double value) {
    return "${(value / scale).toStringAsFixed(1)}$prefix";
  }

  void determineScale() {
    if (maxY < 1000) {
      prefix = "";
      scale = 1;
    } else if (maxY < 999999) {
      prefix = "K";
    } else {
      scale = 1000000;
      prefix = "M";
    }
  }

  void generateDayLogic() {
    interval = 2;
    DateTime now = DateTime.now();

    DateTime currentDate =
        DateState.dateTimeMap(state).add(const Duration(days: 1, hours: 1));

    double currentDaySteps = 0;

    while (currentDate
        .isBefore(DateTime(now.year, now.month, now.day, now.hour + 1))) {
      if (parsedData.containsKey(currentDate)) {
        currentDaySteps = parsedData[currentDate].toDouble()!;
      }

      bottomAxisLabels[maxX.toInt()] = "${currentDate.hour}";

      if (currentDaySteps > maxY) {
        maxY = currentDaySteps;
      }
      spots.add(
        FlSpot(
          maxX,
          currentDaySteps,
        ),
      );

      currentDaySteps = 0;

      currentDate = currentDate.add(const Duration(hours: 1));

      maxX++;
    }
    maxX--;
  }

  void generateWeekLogic() {
    DateTime now = DateTime.now();

    DateTime currentDate = DateState.dateTimeMap(state);
    DateTime lastDate = currentDate;

    double currentDaySteps = 0;

    while (currentDate.isBefore(now)) {
      bool inNewDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day) !=
              DateTime(lastDate.year, lastDate.month, lastDate.day);

      if (inNewDay) {
        String formatedMonth = DateFormat("MMM").format(currentDate);
        bottomAxisLabels[maxX.toInt()] = "$formatedMonth ${currentDate.day}";

        if (currentDaySteps > maxY) {
          maxY = currentDaySteps;
        }
        spots.add(
          FlSpot(
            maxX,
            currentDaySteps,
          ),
        );

        maxX++;
        currentDaySteps = 0;
        lastDate = currentDate;
      }

      if (parsedData.containsKey(currentDate)) {
        currentDaySteps += parsedData[currentDate].toDouble()!;
      }

      currentDate = currentDate.add(const Duration(hours: 1));
    }

    // to get the last day worth of data
    String formatedMonth = DateFormat("MMM").format(currentDate);
    bottomAxisLabels[maxX.toInt()] = "$formatedMonth ${currentDate.day}";
    spots.add(
      FlSpot(
        maxX,
        currentDaySteps,
      ),
    );
    if (currentDaySteps > maxY) {
      maxY = currentDaySteps;
    }
  }

  void generateMonthLogic() {
    // the functions are the exact same except needs higher interval or will looked squished
    generateWeekLogic();
    interval = 4;
  }

  void generateYearLogic() {
    DateTime now = DateTime.now();

    DateTime currentDate = DateState.dateTimeMap(state);
    DateTime lastDate = currentDate;

    double currentMonthSteps = 0;

    while (currentDate.isBefore(now)) {
      bool inNewMonth = DateTime(currentDate.year, currentDate.month) !=
          DateTime(lastDate.year, lastDate.month);

      if (inNewMonth) {
        String formatedMonth = DateFormat("MMM").format(lastDate);
        bottomAxisLabels[maxX.toInt()] = formatedMonth;

        if (currentMonthSteps > maxY) {
          maxY = currentMonthSteps;
        }
        spots.add(
          FlSpot(
            maxX,
            currentMonthSteps,
          ),
        );

        maxX++;
        currentMonthSteps = 0;
        lastDate = currentDate;
      }

      if (parsedData.containsKey(currentDate)) {
        currentMonthSteps += parsedData[currentDate].toDouble()!;
      }

      currentDate = currentDate.add(const Duration(hours: 1));
    }
    String formatedMonth = DateFormat("MMM").format(lastDate);
    bottomAxisLabels[maxX.toInt()] = formatedMonth;

    if (currentMonthSteps > maxY) {
      maxY = currentMonthSteps;
    }

    spots.add(
      FlSpot(
        maxX,
        currentMonthSteps,
      ),
    );
  }

  FLChartReqInfo({
    required this.rawData,
    required this.state,
    required this.table,
  }) {
    for (int i = 0; i < rawData.length; i++) {
      // find maxX
      int steps = rawData[i][table.statColumn]!;
      if (steps > maxY) {
        maxY = steps.toDouble();
      }

      DateTime parsedTime = DateTime.parse(rawData[i]["timeSlice"]!);
      parsedData[parsedTime] = rawData[i][table.statColumn];
    }

    switch (state) {
      case DateState.day:
        generateDayLogic();
        break;
      case DateState.week:
        generateWeekLogic();
        break;
      case DateState.month:
        generateMonthLogic();
        break;
      case DateState.year:
        generateYearLogic();
        break;
    }
    determineScale();
    bottomAxisLabel = DateState.timePeriodAxisMap(state);
    leftAxisLabel = table.statName!;
  }
}

enum GraphState { chart, table }

class StatStateModel {
  late List<bool> dateStateSelections;

  DateState dateState = DateState.day;
  GraphState graphState = GraphState.chart;
  DBTable table;
  FLChartReqInfo plotInfo = FLChartReqInfo(
    rawData: [],
    state: DateState.day,
    table: DBTable.steps,
  );
  //List<Object> tableData = [];

  StatStateModel({required this.table}) {
    resetDateSelections();
    dateStateSelections[DateState.enumToIndex(dateState)] = true;
  }

  Future<List<Map<String, dynamic>>> readDBData() async {
    //DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    DateTime date = DateState.dateTimeMap(dateState);
    var db = await init();
    String query =
        """SELECT * FROM ${table.tableTitle} WHERE DATE(timeSlice) >= ?""";
    List<Object> args = [date.toString()];
    return await db.rawQuery(query, args);
  }

  Future<void> setDateState(int index) async {
    if (DateState.isValidIndex(index)) {
      resetDateSelections();
      dateStateSelections[index] = true;
      dateState = DateState.indexToEnum(index)!;
    }
  }

  void invertGraphState() {
    if (graphState == GraphState.chart) {
      graphState = GraphState.table;
    } else {
      graphState = GraphState.chart;
    }
  }

  void resetDateSelections() {
    dateStateSelections = List.generate(DateState.values.length, (_) => false);
  }
}
