import "package:flutter/material.dart";
import "package:canacache/theming/models/cana_pallet_provider.dart";
import "package:canacache/theming/models/cana_palette_model.dart";
import "package:provider/provider.dart";

SnackBar errorCanaSnackBar(BuildContext context, String message) {
  CanaTheme selectedTheme =
      Provider.of<CanaThemeProvider>(context, listen: false).selectedTheme;

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
      Provider.of<CanaThemeProvider>(context, listen: false).selectedTheme;

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
void challengeSnackBarAsync(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } on Exception catch (error) {
    print(error);

    SnackBar snackBar = errorCanaSnackBar(context, error.toString());
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
