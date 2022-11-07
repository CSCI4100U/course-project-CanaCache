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

SnackBar sucessCanaSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: CanaPalette.primaryIconColor),
    ),
    backgroundColor: CanaPalette.primaryBG,
  );
}

// if an exception is thrown on action show an cana error snackbar otherwise show a cana sucess
// snackbar with sucessText
// action must be an async function
void challengeSnackBarAsync(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } on Exception catch (error) {
    SnackBar snackBar = errorCanaSnackBar(error.toString());
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
