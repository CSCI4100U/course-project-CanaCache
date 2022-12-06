import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/features/stats/view/common_charts.dart";
import "package:flutter/material.dart";

class StepStatView extends LineChartTimeView {
  const StepStatView({Key? key})
      : super(key: key, title: "stats.steps.label", table: DBTable.steps);
}
