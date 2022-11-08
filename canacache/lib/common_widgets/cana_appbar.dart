import "package:flutter/material.dart";
import "package:canacache/theming/models/cana_pallet_provider.dart";
import "package:canacache/theming/models/cana_palette_model.dart";
import "package:provider/provider.dart";

class CanaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffState;
  final String? title;

  const CanaAppBar({super.key, this.title, required this.scaffState});

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme =
        Provider.of<CanaThemeProvider>(context).selectedTheme;

    return AppBar(
      iconTheme: IconThemeData(
        color: selectedTheme.primaryIconColor, //change your color here
      ),
      title: Text(title ?? ""),
      backgroundColor: selectedTheme.primaryBgColor,
      elevation: 1.0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, size: 35),
        onPressed: () => scaffState.currentState!.openDrawer(),
      ),
    );
  }

// taken from here https://stackoverflow.com/questions/64324749/flutter-reuse-of-appbar-widget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/*
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
*/
