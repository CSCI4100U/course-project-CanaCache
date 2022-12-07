import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PickerItem extends StatelessWidget {
  final String Function() buildSnackBarText;
  final String itemText;
  final bool highlight;
  final Future<void> Function() callback;

  const PickerItem({
    super.key,
    required this.buildSnackBarText,
    required this.itemText,
    required this.highlight,
    required this.callback,
  });

  @override
  Widget build(BuildContext context, {mounted = true}) {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;
    // mounted is always true in StatelessWidget

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () async {
          await callback();
          if (!mounted) {
            return;
          }

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            successCanaSnackBar(context, buildSnackBarText()),
          );
        },
        child: Container(
          color: highlight
              ? selectedTheme.secBgColor
              : selectedTheme.primaryBgColor,
          child: Center(
            child: Text(
              itemText,
              style: TextStyle(
                color: selectedTheme.primaryTextColor,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
