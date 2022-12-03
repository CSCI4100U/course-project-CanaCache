import "dart:async";
import "package:canacache/features/app/view/app.dart";
import "package:canacache/features/stepcounter/model/step_recorder.dart";
import "package:flutter/material.dart";

void main() {
  /*
 */

  runApp(const CanaApp());

  StepRecorder recorder = StepRecorder();
  Timer.periodic(
    const Duration(seconds: 1),
    (Timer t) => recorder.makeEpoch(),
  );
}
