import "package:canacache/features/firestore/model/collection_model.dart";
import "package:canacache/features/firestore/model/collections/caches.dart";
import "package:canacache/features/firestore/model/collections/user_items.dart";
import "package:canacache/features/firestore/model/document_model.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A user participating in CanaCache
class CanaUser extends DocumentModel<CanaUser> {
  // fields
  List<DocumentReference<Cache>> visitedCaches;

  CanaUser.withRef({
    required DocumentReference<CanaUser> ref,
    this.visitedCaches = const [],
  }) : super(ref);

  CanaUser.fromMap(Map<String, dynamic> map, super.ref)
      : visitedCaches = Caches().convertDocumentReferences(
          // need this in case the list is empty
          List<RawDocumentReference>.from(map["visitedCaches"]),
        );

  @override
  Map<String, dynamic> toMap() => {
        "visitedCaches": visitedCaches,
      };

  @override
  Future<void> delete() async {
    for (final item in await UserItems(ref).getObjects()) {
      await item.delete();
    }
    return super.delete();
  }
}
