import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/features/stats/view/common_charts.dart";
import "package:flutter/material.dart";

class DistanceStatView extends LineChartTimeView {
  const DistanceStatView({Key? key})
      : super(
          key: key,
          title: "stats.distance.title",
          table: DBTable.distance,
        );
}
