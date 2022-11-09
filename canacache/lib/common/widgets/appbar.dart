import "package:canacache/common/utils/palette.dart";
import "package:flutter/material.dart";

class CanaAppBar extends AppBar {
  final GlobalKey<ScaffoldState> scaffState;
  final String? titleStr;

  CanaAppBar({
    super.key,
    this.titleStr,
    required this.scaffState,
    super.actions,
  }) : super(
          iconTheme: const IconThemeData(
            color: CanaPalette.primaryIconColor, //change your color here
          ),
          title: Text(titleStr ?? ""),
          backgroundColor: CanaPalette.primaryBG,
          elevation: 1.0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, size: 35),
            onPressed: () => scaffState.currentState!.openDrawer(),
          ),
        );
}
