import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/formatting_extensions.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/controller/cache_list_controller.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";


// this is in its own widget so that opening a cache doesn't refresh the stream
// which was causing a loading indicator to briefly flicker
class CacheList extends StatefulWidget {
  final List<Cache> caches;

  const CacheList({super.key, required this.caches});

  @override
  State<CacheList> createState() => CacheListState();
}

class CacheListState extends ViewState<CacheList, CacheListController> {
  CacheListState() : super(CacheListController());

  bool sortAscending = false;
  int sortIndex = 0;

  @override
  Widget build(BuildContext context) {
    CanaTheme theme = Provider.of<SettingsProvider>(context).theme;


    return DataTable(columns: <DataColumn> [
      DataColumn(
          label: Text(
            translate("Title"),
            style: TextStyle(
                color: theme.primaryTextColor,
                fontFamily: theme.primaryFontFamily,
            ),
          ),
          numeric: false,
          onSort: (int index, _) {
            setState(() {
              sortIndex = index;
              if (sortAscending == true) {
                sortAscending = false;
                widget.caches.sort((A, B) =>
                    B.name.compareTo(A.name),);
              } else {
                sortAscending = true;
                widget.caches.sort((A, B) =>
                    A.name.compareTo(B.name),);
              }
            });
          },
      ),
      DataColumn(
        label: Text(
          translate("Location"),
          style: TextStyle(
            color: theme.primaryTextColor,
            fontFamily: theme.primaryFontFamily,
          ),
        ),
        numeric: true,
        onSort: (int index, _) {
          setState(() {
            sortIndex = index;
            if (sortAscending == true) {
              sortAscending = false;
                widget.caches.sort((A, B) {
                  double aLongDiff = 43.9457895491046 - A.position.longitude;
                  double bLongDiff = 43.9457895491046 - B.position.longitude;

                  double aLatDiff = -78.89677587312467 - A.position.latitude;
                  double bLatDiff = -78.89677587312467 - B.position.latitude;

                  double aDiff = aLongDiff.abs() + aLatDiff.abs();
                  double bDiff = bLongDiff.abs() + bLatDiff.abs();

                  return aDiff > bDiff ? 0 : 1;
                });
              } else {
              sortAscending = true;
              widget.caches.sort((A, B) {
                double aLongDiff = 43.9457895491046 - A.position.longitude;
                double bLongDiff = 43.9457895491046 - B.position.longitude;

                double aLatDiff = -78.89677587312467 - A.position.latitude;
                double bLatDiff = -78.89677587312467 - B.position.latitude;

                double aDiff = aLongDiff.abs() + aLatDiff.abs();
                double bDiff = bLongDiff.abs() + bLatDiff.abs();

                return aDiff > bDiff ? 1 : 0;
              }
              );
              }
          });
        },
      ),
    ],
      rows: List<DataRow>.generate(
        widget.caches.length,
            (index) => DataRow(cells: [
              DataCell(Text(
                widget.caches[index].name,
                style: TextStyle(
                    color: theme.primaryTextColor,
                    fontFamily: theme.primaryFontFamily,
                ),
              ),
              ),
              DataCell(Text(
                widget.caches[index].position.toLatLng(),
                style: TextStyle(
                  color: theme.primaryTextColor,
                  fontFamily: theme.primaryFontFamily,
                ),
              ),
              ),
            ],
            ),
      ),
    );
  }
}
