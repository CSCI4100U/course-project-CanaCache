import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class EditableTextButton extends StatelessWidget {
  final String titleExisting;
  final String titleNew;
  final String? text;
  final VoidCallback onPressed;

  const EditableTextButton({
    super.key,
    required this.titleExisting,
    required this.titleNew,
    required this.text,
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
          Expanded(
            child: Column(
              children: [
                Text(
                  text != null ? titleExisting : titleNew,
                  style: TextStyle(
                    color: theme.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (text != null)
                  Container(
                    padding: const EdgeInsets.only(top: 4, left: 2, right: 2),
                    child: Text(
                      text!,
                      textAlign: TextAlign.justify, // justify looks prettier
                      style: TextStyle(color: theme.primaryTextColor),
                    ),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.primaryIconColor, size: 24),
        ],
      ),
    );
  }
}
