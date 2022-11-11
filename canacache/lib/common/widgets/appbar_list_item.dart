import "package:canacache/common/utils/routes.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/theming/models/cana_palette_model.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class CanaAppBarListItem extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final CanaRoute route;
  final bool clearNavigation;
  final VoidCallback? callback;

  const CanaAppBarListItem({
    super.key,
    this.iconData,
    required this.label,
    required this.route,
    this.callback,
    this.clearNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;

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
      onPressed: () {
        if (callback != null) {
          callback!();
        }

        if (clearNavigation) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            route.name,
            (val) => false,
          );
        } else {
          Navigator.pushNamed(context, route.name);
        }
      },
    );
  }
}
