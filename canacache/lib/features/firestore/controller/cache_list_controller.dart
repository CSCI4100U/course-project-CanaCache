import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list_page.dart";

class Sorter {
  final Comparator<CacheAndDistance> compareAscending;
  final Comparator<CacheAndDistance> compareDescending;

  Sorter({required this.compareAscending, required this.compareDescending});

  Comparator<CacheAndDistance> getCompare(bool ascending) =>
      ascending ? compareAscending : compareDescending;
}

class CacheListController extends Controller<CacheList, CacheListState> {
  // this is also bad!
  // it should really be defined in the same place as the columns
  // TODO: fix this (when? lol)
  final sorters = [
    // name
    Sorter(
      compareAscending: (a, b) => a.cache.name.compareTo(b.cache.name),
      compareDescending: (a, b) => b.cache.name.compareTo(a.cache.name),
    ),
    // distance
    Sorter(
      compareAscending: (a, b) => a.distance.compareTo(b.distance),
      compareDescending: (a, b) => b.distance.compareTo(a.distance),
    )
  ];

  void sortCaches(int columnIndex, bool ascending) {
    state.widget.items.sort(sorters[columnIndex].getCompare(ascending));
  }

  void sortCachesAndUpdate(int columnIndex, bool ascending) {
    setState(() {
      state.sortAscending = ascending;
      state.sortColumnIndex = columnIndex;
      sortCaches(columnIndex, ascending);
    });
  }
}
