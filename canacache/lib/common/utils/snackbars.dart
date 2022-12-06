import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

SnackBar errorCanaSnackBar(BuildContext context, String message) {
  CanaTheme selectedTheme =
      Provider.of<SettingsProvider>(context, listen: false).theme;
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: selectedTheme.errorTextColor),
    ),
    backgroundColor: selectedTheme.errorBgColor,
  );
}

SnackBar successCanaSnackBar(BuildContext context, String message) {
  CanaTheme selectedTheme =
      Provider.of<SettingsProvider>(context, listen: false).theme;
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: selectedTheme.primaryTextColor),
    ),
    backgroundColor: selectedTheme.primaryBgColor,
  );
}

// if an exception is thrown on action show a cana error snackbar otherwise show a cana success
// snackbar with successText
// action must be an async function
Future<void> challengeSnackBarAsync(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } on Exception catch (error) {
    SnackBar snackBar = errorCanaSnackBar(context, error.toString());
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    rethrow;
  }
}
