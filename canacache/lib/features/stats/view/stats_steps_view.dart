import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/stats/controller/step_stats_controller.dart";
import "package:canacache/features/stats/model/stat_state.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class StepStatView extends StatefulWidget {
  const StepStatView({Key? key}) : super(key: key);

  @override
  State createState() => StepStatViewState();
}

class StepStatViewState extends ViewState<StepStatView, StepStatController> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  StepStatViewState() : super(StepStatController());

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
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 60),
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    String text = con.plotInfo.getLeftWidgetText(value);
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData generateData(BuildContext context) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: con.plotInfo.scale.toDouble(),
        verticalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
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
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: con.plotInfo.interval,
            getTitlesWidget: bottomTitleWidgetsClosure(context),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (con.plotInfo.maxY / 10) + 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
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
