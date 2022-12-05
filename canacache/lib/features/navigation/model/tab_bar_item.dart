import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";

class TabBarItem {
  final IconData iconData;
  final String titleKey;
  final Widget page;

  const TabBarItem({
    required this.iconData,
    required this.titleKey,
    required this.page,
  });

  Tab get tab => Tab(icon: Icon(iconData));
  String get title => translate(titleKey);
}
