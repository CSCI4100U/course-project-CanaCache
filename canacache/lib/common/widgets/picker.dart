import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

void canaShowDialog(
  BuildContext context,
  Widget content,
  String title,
  {List<Widget>? actions,}
) async {
  CanaTheme selectedTheme =
      Provider.of<SettingsProvider>(context, listen: false).theme;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      backgroundColor: selectedTheme.primaryBgColor,
      title: Text(
        title,
        style: TextStyle(
          color: selectedTheme.primaryTextColor,
        ),
      ),
      content: content,
      actions: actions ?? [],
    ),
  );
}
