import "package:canacache/common/utils/formatting.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/controller/cache_list_controller.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list_page.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";

class CacheList extends StatefulWidget {
  final List<CacheAndDistance> items;
  final CanaUser user;

  const CacheList({super.key, required this.items, required this.user});

  @override
  State<CacheList> createState() => CacheListState();
}

class CacheListState extends ViewState<CacheList, CacheListController> {
  CacheListState() : super(CacheListController());

  bool sortAscending = false;
  int? sortColumnIndex;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = settings.theme;

    // this is really bad.
    // there's probably a better way to do this other than SORTING ON EVERY BUILD
    // but i do not have time to find it
    if (sortColumnIndex != null) {
      con.sortCaches(sortColumnIndex!, sortAscending);
    }

    return InteractiveViewer(
      constrained: false,
      child: DataTable(
        columnSpacing: 1,
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        columns: [
          DataColumn(
            label: Icon(Icons.star, color: theme.primaryIconColor),
            onSort: con.sortCachesAndUpdate,
          ),
          DataColumn(
            label: Text(
              translate("list.title"),
              style: TextStyle(color: theme.primaryTextColor),
            ),
            numeric: false,
            onSort: con.sortCachesAndUpdate,
          ),
          DataColumn(
            label: Text(
              translate("list.distance"),
              style: TextStyle(color: theme.primaryTextColor),
            ),
            numeric: true,
            onSort: con.sortCachesAndUpdate,
          ),
        ],
        rows: widget.items
            .map(
              (item) => DataRow(
                cells: [
                  DataCell(
                    Stack(
                      children: [
                        // fancy two-tone star uwu
                        if (item.isStarred)
                          Icon(
                            Icons.star,
                            color: theme.secIconColor,
                          ),
                        Icon(
                          Icons.star_border,
                          color: theme.primaryIconColor,
                        ),
                      ],
                    ),
                    onTap: () => con.toggleCacheStar(item),
                  ),
                  DataCell(
                    Text(
                      item.cache.name,
                      style: TextStyle(color: theme.primaryTextColor),
                    ),
                  ),
                  DataCell(
                    Text(
                      formatDistance(item.distance, settings),
                      style: TextStyle(color: theme.primaryTextColor),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
