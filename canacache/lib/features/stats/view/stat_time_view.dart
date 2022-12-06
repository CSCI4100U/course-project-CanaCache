import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/features/stats/view/common_charts.dart";
import "package:flutter/material.dart";

class TimeStatView extends LineChartTimeView {
  const TimeStatView({Key? key})
      : super(key: key, title: "stats.mins.title", table: DBTable.mins);
}
