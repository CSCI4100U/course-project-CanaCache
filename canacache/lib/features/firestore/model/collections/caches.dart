import "package:canacache/features/firestore/model/collection_model.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Caches extends CollectionModel<Cache> {
  @override
  final collectionName = "caches";

  @override
  Cache fromMap(Map<String, dynamic> map, DocumentReference<Cache> ref) {
    return Cache.fromMap(map, ref);
  }
}
