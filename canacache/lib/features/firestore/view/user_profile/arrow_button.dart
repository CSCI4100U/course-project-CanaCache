import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ArrowButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const ArrowButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsProvider>(context).theme;

    return ElevatedButton(
      style: ButtonStyle(
        // stop the button from CHANGING ITS EXTERNAL PADDING BASED ON ITS CONTENTS
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // SERIOUSLY WHY IS THAT THE DEFAULT
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        ),
        backgroundColor: MaterialStatePropertyAll(theme.primaryBgColor),
        overlayColor: MaterialStatePropertyAll(theme.secBgColor),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24), // same as icon size at other end
          child,
          Icon(Icons.chevron_right, color: theme.primaryIconColor, size: 24),
        ],
      ),
    );
  }
}
