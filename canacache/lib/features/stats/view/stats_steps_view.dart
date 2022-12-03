import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/stats/controller/step_stats_controller.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class StepStatView extends StatefulWidget {
  const StepStatView({Key? key}) : super(key: key);

  @override
  State createState() => StepStatViewState();
}

class StepStatViewState extends ViewState<StepStatView, StepStatController> {
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

    return CanaScaffold(
      title: "Step Stats",
      body: const Text("ttest"),
      /*
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 10,
            child: buttons,
          ),
        ],
      ),
      */
    );
  }
}
