import "package:flutter/material.dart";

class TabBarItem {
  final IconData iconData;
  final String title;
  final Widget page;

  const TabBarItem({
    required this.iconData,
    required this.title,
    required this.page,
  });

  Tab get tab => Tab(icon: Icon(iconData));
}
