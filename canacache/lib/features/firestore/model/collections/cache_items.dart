import "package:canacache/features/firestore/model/collection_model.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/model/documents/item.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class CacheItems extends SubcollectionModel<Item, Cache> {
  @override
  final collectionName = "items";

  CacheItems(super.parentRef);

  @override
  Item fromMap(Map<String, dynamic> map, DocumentReference<Item> ref) {
    return Item.fromMap(map, ref);
  }
}
