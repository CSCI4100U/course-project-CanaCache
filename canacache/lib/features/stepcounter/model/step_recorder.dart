import "package:pedometer/pedometer.dart";
import "dart:async";
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
    print("setup listen");
  }

  // this class will record steps for current hour in a database

  makeEpoch() {
    int d_steps = stepsSinceAppStart - lastEpochStepCount;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, now.hour);
    print(date);
    lastEpochStepCount = stepsSinceAppStart;
  }

  void onStepCount(StepCount event) {
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
