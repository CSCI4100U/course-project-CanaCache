import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:provider/provider.dart";

class CanaAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const height = kToolbarHeight;
  final String? title;
  final bool? hideLogo;

  const CanaAppBar({super.key, this.title, this.hideLogo});

  @override
  Widget build(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;

    // this is how AppBar decides if it should show a back button
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final backButtonIsVisible = parentRoute?.impliesAppBarDismissal ?? false;
    final hideLogo = (this.hideLogo ?? false) || backButtonIsVisible;

    return AppBar(
      iconTheme: IconThemeData(
        color: selectedTheme.primaryIconColor, //change your color here
      ),
      titleSpacing: hideLogo ? null : 4,
      title: Row(
        children: [
          if (!hideLogo)
            SvgPicture.asset("assets/vectors/logo.svg", height: height),
          Text(
            title ?? "",
            style: TextStyle(color: selectedTheme.primaryTextColor),
          ),
        ],
      ),
      backgroundColor: selectedTheme.primaryBgColor,
      elevation: 1.0,
      toolbarHeight: height,
      actions: backButtonIsVisible
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.of(context).pushNamed(
                  CanaRoute.settings.name,
                ),
                padding: const EdgeInsets.only(right: 12),
              ),
            ],
    );
  }

// taken from here https://stackoverflow.com/questions/64324749/flutter-reuse-of-appbar-widget
  @override
  Size get preferredSize => const Size.fromHeight(height);
}
