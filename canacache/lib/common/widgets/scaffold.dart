import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/widgets/appbar.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class CanaScaffold extends StatelessWidget {
  final String? title;
  final GlobalKey<ScaffoldState> _scaffState = GlobalKey<ScaffoldState>();
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;

  CanaScaffold({
    super.key,
    this.title,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    return Scaffold(
      appBar: appBar ?? CanaAppBar(title: title),
      backgroundColor: theme.secBgColor,
      key: _scaffState,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
