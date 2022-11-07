import "package:flutter/material.dart";
import "package:app/utils/canna_pallet.dart";

SnackBar errorCanaSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: CannaPallet.primaryErrorIconColor),
    ),
    backgroundColor: CannaPallet.primaryErrorBG,
  );
}

SnackBar sucessCanaSnackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: CannaPallet.primaryIconColor),
    ),
    backgroundColor: CannaPallet.primaryBG,
  );
}

// if an exception is thrown on action show an cana error snackbar otherwise show a cana sucess
// snackbar with sucessText
// action must be an async function
void challengeSnackBarAsync(
    BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } on Exception catch (error) {
    SnackBar snackBar = errorCanaSnackBar(error.toString());
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
