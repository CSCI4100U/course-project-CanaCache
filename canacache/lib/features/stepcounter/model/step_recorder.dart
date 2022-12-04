import "dart:async";
import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/db_setup.dart";
import "package:pedometer/pedometer.dart";
import "package:permission_handler/permission_handler.dart";

class StepRecorder {
  bool firstRecording = true;
  int stepsSinceSystemBoot = 0;
  int stepsSinceAppStart = 0;
  int lastEpochStepCount = 0;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  StepRecorder() {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Permission.activityRecognition.request();
    if (await Permission.activityRecognition.isDenied) {
      await Permission.activityRecognition.request();
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    _stepCountStream.listen(onStepCount);
  }

  // this class will record steps for current hour in a database

  newEpoch() async {
    int dSteps = stepsSinceAppStart - lastEpochStepCount;
    print("d steps $dSteps");
    if (dSteps > 0) {
      DateTime now = DateTime.now();
      DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
      var db = await initDB();

      List<Object> args = [currentHour.toString(), dSteps, dSteps];

      String dbString =
          """INSERT INTO ${dbTables[LocalDBTables.steps]!.tableTitle} (timeSlice, steps)
              VALUES(?,?)
              ON CONFLICT(timeSlice)
              DO UPDATE SET steps = steps+?;""";

      await db.execute(dbString, args);
    }

    lastEpochStepCount = stepsSinceAppStart;
  }

  void onStepCount(StepCount event) {
    print("on step");
    if (firstRecording) {
      firstRecording = false;
      stepsSinceSystemBoot = event.steps;
      lastEpochStepCount =
          stepsSinceSystemBoot - stepsSinceSystemBoot + event.steps;
    }
    stepsSinceAppStart =
        stepsSinceSystemBoot - stepsSinceSystemBoot + event.steps;
  }
}
