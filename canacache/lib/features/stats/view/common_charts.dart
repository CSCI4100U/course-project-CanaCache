import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/db_schema.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/stats/controller/common_stats_controller.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class LineChartTimeView extends StatefulWidget {
  final String title;
  final LocalDBTables table;

  const LineChartTimeView({Key? key, required this.title, required this.table})
      : super(key: key);

  @override
  State createState() => LineChartTimeViewState(title: title, table: table);
}

class LineChartTimeViewState
    extends ViewState<LineChartTimeView, CommonStatController> {
  final String title;
  final LocalDBTables table;

  LineChartTimeViewState({required this.title, required this.table})
      : super(CommonStatController(table: table));

  @override
  Widget build(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    List<Widget> dateOptions = const [
      Text("Day"),
      Text("Week"),
      Text("Month"),
      Text("Year"),
    ];

    ToggleButtons buttons = ToggleButtons(
      isSelected: con.selections,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      fillColor: theme.primaryBgColor,
      selectedColor: theme.secTextColor,
      disabledColor: theme.primaryTextColor,
      selectedBorderColor: theme.secTextColor,
      borderColor: theme.primaryTextColor,
      color: theme.primaryTextColor,
      onPressed: (int index) => con.dateButtonController(index),
      children: dateOptions,
    );

    LineChart chart = LineChart(generateData(context));

    // as a starting point example code from https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/line_chart/samples/line_chart_sample2.dart was used
    // it is basically unrecognizable now though

    return CanaScaffold(
      title: "Step Stats",
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 20, bottom: 30, top: 50),
        child: Column(
          children: [
            Flexible(flex: 10, child: chart),
            Flexible(
              flex: 1,
              child: buttons,
            ),
          ],
        ),
      ),
    );
  }

  Widget Function(double value, TitleMeta meta) bottomTitleWidgetsClosure(
      BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    Widget bottomTitleWidgets(double value, TitleMeta meta) {
      var style = TextStyle(
        color: theme.primaryTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );

      String rawText = value.toInt().toString();
      if (con.plotInfo.bottomAxisLabels.containsKey(value.toInt())) {
        rawText = con.plotInfo.bottomAxisLabels[value.toInt()];
      }

      Widget text = Text(rawText, style: style);

      return SideTitleWidget(
        axisSide: meta.axisSide,
        angle: 45,
        child: text,
      );
    }

    return bottomTitleWidgets;
  }

  Widget Function(double value, TitleMeta meta) leftTitleWidgetsClosure(
      BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;
    Widget leftTitleWidgets(double value, TitleMeta meta) {
      var style = TextStyle(
        color: theme.primaryTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );

      String text = con.plotInfo.getLeftWidgetText(value);
      return Text(text, style: style, textAlign: TextAlign.left);
    }

    return leftTitleWidgets;
  }

  LineChartData generateData(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    int diff = theme.secIconColor.value - 70;
    List<Color> gradientColors = [
      Color(diff),
      theme.secIconColor,
    ];

    var style = TextStyle(
      color: theme.primaryTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: con.plotInfo.scale.toDouble(),
        verticalInterval: 20,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(con.plotInfo.bottomAxisLabel, style: style),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: con.plotInfo.interval,
            getTitlesWidget: bottomTitleWidgetsClosure(context),
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(con.plotInfo.leftAxisLabel, style: style),
          sideTitles: SideTitles(
            showTitles: true,
            interval: (con.plotInfo.maxY / 10) + 1,
            getTitlesWidget: leftTitleWidgetsClosure(context),
            reservedSize: 50,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: theme.primaryTextColor),
      ),
      minX: con.plotInfo.minX,
      maxX: con.plotInfo.maxX,
      minY: 0,
      maxY: con.plotInfo.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: con.plotInfo.spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
