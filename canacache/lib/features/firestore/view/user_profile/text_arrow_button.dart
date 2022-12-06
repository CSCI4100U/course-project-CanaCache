import "package:canacache/features/firestore/view/user_profile/arrow_button.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class TextArrowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const TextArrowButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsProvider>(context).theme;

    return ArrowButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: theme.primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
