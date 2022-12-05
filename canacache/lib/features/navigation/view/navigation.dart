import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/firestore/view/cache_list_page.dart";
import "package:canacache/features/homepage/view/homepage.dart";
import "package:canacache/features/navigation/model/tab_bar_item.dart";
import "package:canacache/features/navigation/view/tab_bar_appbar.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";

class NavigationPage extends StatefulWidget {
  final items = [
    TabBarItem(
      iconData: Icons.home,
      title: translate("navbar.titles.home"),
      page: const HomePage(),
    ),
    TabBarItem(
      iconData: Icons.location_on,
      title: translate("navbar.titles.caches"),
      page: const CacheListPage(),
    ),
    TabBarItem(
      iconData: Icons.multiline_chart,
      title: translate("navbar.titles.stats"),
      page: const Placeholder(),
    ),
    TabBarItem(
      iconData: Icons.person,
      title: translate("navbar.titles.account"),
      page: const Placeholder(),
    ),
  ];

  NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.items.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsProvider>(context).theme;

    return CanaScaffold(
      appBar: TabBarAppBar(items: widget.items, tabController: _tabController),
      bottomNavigationBar: Container(
        color: theme.primaryBgColor,
        child: TabBar(
          controller: _tabController,
          labelColor: theme.primaryTextColor,
          tabs: widget.items.map((item) => item.tab).toList(),
        ),
      ),
      body: TabBarView(
        // swiping interferes with map panning
        // remove this if we move the map somewhere else
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: widget.items.map((item) => item.page).toList(),
      ),
    );
  }
}
