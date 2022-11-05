import "package:flutter/material.dart";
import "package:app/utils/canna_pallet.dart";

class CannaAppbar extends AppBar {
  final GlobalKey<ScaffoldState> scaffState;

  CannaAppbar({super.key, required this.scaffState, super.actions})
      : super(
          iconTheme: const IconThemeData(
            color: CannaPallet.primaryIconColor, //change your color here
          ),
          backgroundColor: CannaPallet.primaryBG,
          elevation: 1.0,
          automaticallyImplyLeading: true,
          leading: IconButton(
              icon: const Icon(Icons.menu, size: 35),
              onPressed: () => scaffState.currentState!.openDrawer()),
        );
}
