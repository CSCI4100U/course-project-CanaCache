import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:canacache/theming/models/cana_pallet_provider.dart";
import "package:canacache/theming/models/cana_palette_model.dart";

class CanaAppBarListItem extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final VoidCallback callback;

  const CanaAppBarListItem({
    super.key,
    this.iconData,
    required this.label,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme =
        Provider.of<CanaThemeProvider>(context).selectedTheme;

    return TextButton.icon(
      icon: Icon(
        iconData,
        color: selectedTheme.secIconColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selectedTheme.primaryTextColor,
          fontFamily: selectedTheme.primaryFontFamily,
        ),
      ),
      onPressed: () => callback(),
    );
  }
}
