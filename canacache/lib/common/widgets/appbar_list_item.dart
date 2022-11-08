import "package:flutter/material.dart";
import "package:canacache/common/utils/palette.dart";

class CanaAppBarListItem extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final String route;
  final VoidCallback? callback;

  const CanaAppBarListItem({
    super.key,
    this.iconData,
    required this.label,
    required this.route,
    this.callback,
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
        Navigator.pushNamed(context, route);
      },
    );
  }
}
