import "package:canacache/common/widgets/appbar.dart";
import "package:canacache/features/navigation/model/tab_bar_item.dart";
import "package:flutter/material.dart";

// this needs to be a separate widget so that the entire body doesn't rebuild when the title changes
class TabBarAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<TabBarItem> items;
  final TabController tabController;

  const TabBarAppBar({
    super.key,
    required this.items,
    required this.tabController,
  });

  @override
  State<TabBarAppBar> createState() => _TabBarAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(CanaAppBar.height);
}

class _TabBarAppBarState extends State<TabBarAppBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tabController.index;
    widget.tabController.addListener(selectedIndexListener);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(selectedIndexListener);
    super.dispose();
  }

  void selectedIndexListener() {
    if (!widget.tabController.indexIsChanging) {
      setState(() => _selectedIndex = widget.tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CanaAppBar(title: widget.items[_selectedIndex].title);
  }
}
