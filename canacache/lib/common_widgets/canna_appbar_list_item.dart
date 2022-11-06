import "package:flutter/material.dart";
import "package:canacache/utils/canna_pallet.dart";

class CannaAppBarListItem extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final VoidCallback callBack;

  const CannaAppBarListItem(
      {super.key, this.iconData, required this.label, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: Icon(
          iconData,
          color: CannaPallet.secondaryIconColor,
        ),
        label: Text(label,
            style: const TextStyle(
                color: CannaPallet.primaryIconColor,
                fontFamily: CannaPallet.primaryFontFamily)),
        onPressed: () => callBack());
  }
}
