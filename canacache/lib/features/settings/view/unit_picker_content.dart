import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:canacache/features/settings/view/picker_item.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";

import "package:provider/provider.dart";

class UnitPickerContent extends StatelessWidget {
  const UnitPickerContent({super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];

    Unit providedUnit =
        Provider.of<SettingsProvider>(context, listen: false).unit;

    for (DistanceUnit k in DistanceUnit.values) {
      Unit currentUnit = Unit(distanceUnit: k);

      content.add(
        PickerItem(
          buildSnackBarText: () => translate(
            "settings.units.distance.change",
            args: {
              "distance": translate(currentUnit.distanceUnit.nameKey),
            },
          ),
          itemText: translate(k.nameKey),
          highlight: currentUnit.distanceUnit == providedUnit.distanceUnit,
          callback: () async =>
              Provider.of<SettingsProvider>(context, listen: false).unit =
                  currentUnit,
        ),
      );
    }
    return Column(children: content);
  }
}
