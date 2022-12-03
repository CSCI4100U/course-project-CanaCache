import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/widgets/appbar_list_item.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class StatHomeView extends StatelessWidget {
  List<Widget> generateNavButtons(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    List<Widget> buttons = [];
    Divider divider = Divider(
      height: 7,
      thickness: 3,
      indent: 0,
      color: theme.primaryBgColor,
      endIndent: 0,
    );

    buttons.addAll(
      [
        const CanaAppBarListItem(
          label: "Steps Stats",
          iconData: Icons.directions_walk,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const CanaAppBarListItem(
          label: "Time Spent",
          iconData: Icons.hourglass_top,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const CanaAppBarListItem(
          label: "Distance Traveled",
          iconData: Icons.speed,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const CanaAppBarListItem(
          label: "Movement History",
          iconData: Icons.run_circle,
          route: CanaRoute.statsSteps,
        ),
        divider,
        const CanaAppBarListItem(
          label: "Dummy Data (Will populate db with dummy data)",
          iconData: Icons.recycling,
          route: CanaRoute.statsSteps,
        ),
      ],
    );
    return buttons;
  }

  const StatHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CanaScaffold(
      title: "Stats",
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: generateNavButtons(context),
          ),
        ),
      ),
    );
  }
}
