import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/view/cache_list.dart";

class CacheListController extends Controller<CacheList, CacheListState> {
  int? selectedIndex;

  void onTap(int index) {
    setState(() => selectedIndex = selectedIndex == index ? null : index);
  }
}
