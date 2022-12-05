import "dart:async";
import "package:canacache/features/app/view/app.dart";
import "package:canacache/features/stats_recording/step_recorder.dart";
import "package:canacache/features/stats_recording/time_recorder.dart";
import "package:canacache/features/stats_recording/distance_recorder.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

void main() async {
  // lock to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const CanaApp());

  StepRecorder stepRecorder = StepRecorder();
  TimeRecorder timeRecorder = TimeRecorder();
  DistanceRecorder distRecorder = DistanceRecorder();

  Timer.periodic(
    const Duration(seconds: StepRecorder.interval),
    (Timer t) => stepRecorder.newEpoch(),
  );

  Timer.periodic(
    const Duration(seconds: TimeRecorder.interval),
    (Timer t) => timeRecorder.newEpoch(),
  );

  Timer.periodic(
    const Duration(seconds: DistanceRecorder.interval),
    (Timer t) => distRecorder.newEpoch(),
  );
}
