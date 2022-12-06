import "package:canacache/common/utils/db_ops.dart";
import "package:canacache/common/utils/db_schema.dart";

class TimeRecorder {
  static const interval = 60;

  Future<void> newEpoch() async {
    DateTime now = DateTime.now();
    DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    var db = await init();

    // this function will run once a min
    List<Object> args = [currentHour.toString(), 1, 1];

    String dbString =
        """INSERT INTO ${DBTable.mins.tableTitle} (timeSlice, mins)
              VALUES(?,?)
              ON CONFLICT(timeSlice)
              DO UPDATE SET mins = mins+?;""";

    await db.execute(dbString, args);
  }
}
