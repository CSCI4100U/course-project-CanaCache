import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/model/cache.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/view/cache_list.dart";

class CacheListController extends Controller<CacheList, CacheListState> {
  Stream<List<Cache>> getCacheStream() => streamObjects(Cache.serializer);
}
