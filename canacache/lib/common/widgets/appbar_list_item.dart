import "package:canacache/common/utils/palette.dart";
import "package:canacache/common/utils/routes.dart";
import "package:flutter/material.dart";

class CanaAppBarListItem extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final CanaRoute route;
  final VoidCallback? callback;
  final bool clearHistory;

  const CanaAppBarListItem({
    super.key,
    this.iconData,
    required this.label,
    required this.route,
    this.callback,
    this.clearHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        iconData,
        color: CanaPalette.secondaryIconColor,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: CanaPalette.primaryIconColor,
          fontFamily: CanaPalette.primaryFontFamily,
        ),
      ),
      onPressed: () {
        if (callback != null) callback!();
        if (clearHistory) {
          Navigator.pushNamedAndRemoveUntil(context, route.name, (r) => false);
        } else {
          Navigator.pushNamed(context, route.name);
        }
      },
    );
  }
}
