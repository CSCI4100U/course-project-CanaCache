import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/view/picker_item.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";

class ThemePickerContent extends StatelessWidget {
  const ThemePickerContent({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;

    for (final theme in CanaTheme.values) {
      content.add(
        PickerItem(
          buildSnackBarText: () => translate(
            "settings.theme.colour.change",
            args: {"theme": translate(theme.nameKey)},
          ),
          itemText: translate(theme.nameKey),
          highlight: theme == selectedTheme,
          callback: () async =>
              Provider.of<SettingsProvider>(context, listen: false).theme =
                  theme,
        ),
      );
    }

    return Column(children: content);
  }
}
