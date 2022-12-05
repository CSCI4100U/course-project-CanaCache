import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";

class TimeRecorder {
  static const interval = 60;

  newEpoch() async {
    print("new time");
    DateTime now = DateTime.now();
    DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    var db = await initDB();

    // this function will run once a min
    List<Object> args = [currentHour.toString(), 1, 1];

    String dbString =
        """INSERT INTO ${dbTables[LocalDBTables.mins]!.tableTitle} (timeSlice, mins)
              VALUES(?,?)
              ON CONFLICT(timeSlice)
              DO UPDATE SET mins = mins+?;""";

    await db.execute(dbString, args);
  }
}
