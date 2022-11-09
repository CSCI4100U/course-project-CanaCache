import "package:canacache/theming/models/cana_palette_model.dart";
import "package:provider/provider.dart";
import "package:canacache/settings/model/settings_provider.dart";
import "package:flutter/material.dart";

class CanaPicker {
  static canaShowDialog(
    BuildContext context,
    Widget content,
    String title,
  ) async {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).getTheme();

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
      ),
    );
  }
}
