import "package:flutter/material.dart";
import "package:canacache/utils/canna_pallet.dart";

class CannaAppbar extends AppBar {
  final GlobalKey<ScaffoldState> scaffState;
  final String? titleStr;

  CannaAppbar({
    super.key,
    this.titleStr,
    required this.scaffState,
    super.actions,
  }) : super(
          iconTheme: const IconThemeData(
            color: CannaPallet.primaryIconColor, //change your color here
          ),
          title: Text(titleStr ?? ""),
          backgroundColor: CannaPallet.primaryBG,
          elevation: 1.0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, size: 35),
            onPressed: () => scaffState.currentState!.openDrawer(),
          ),
        );
}
