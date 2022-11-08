import "package:flutter/material.dart";
import "package:canacache/utils/cana_palette.dart";

SnackBar errorCanaSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: CanaPalette.primaryErrorIconColor),
    ),
    backgroundColor: CanaPalette.primaryErrorBG,
  );
}

SnackBar successCanaSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: CanaPalette.primaryIconColor),
    ),
    backgroundColor: CanaPalette.primaryBG,
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
    SnackBar snackBar = errorCanaSnackBar(error.toString());
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
