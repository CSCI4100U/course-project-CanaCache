import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list_page.dart";

class Sorter {
  final Comparator<CacheAndDistance> compareAscending;

  Sorter(this.compareAscending);

  Comparator<CacheAndDistance> getCompare(bool ascending) =>
      ascending ? compareAscending : compareDescending;

  int compareDescending(CacheAndDistance a, CacheAndDistance b) {
    return compareAscending(b, a);
  }
}

class CacheListController extends Controller<CacheList, CacheListState> {
  // this is also bad!
  // it should really be defined in the same place as the columns
  // TODO: fix this (when? lol)
  final sorters = [
    // starred
    Sorter((a, b) {
      if (a.isStarred == b.isStarred) return 0;
      if (b.isStarred) return 1;
      return -1;
    }),
    // name
    Sorter(
      (a, b) =>
          a.cache.name.toLowerCase().compareTo(b.cache.name.toLowerCase()),
    ),
    // distance
    Sorter((a, b) => a.distance.compareTo(b.distance)),
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

  void toggleCacheStar(CacheAndDistance item) {
    final user = state.widget.user;

    if (item.isStarred) {
      user.starredCaches.removeWhere((ref) => ref.id == item.cache.ref.id);
    } else {
      user.starredCaches.add(item.cache.ref);
    }

    // apparently firestore is fast/optimized enough that we don't need to worry about updating the list
    // yay!
    user.update();
  }
}
