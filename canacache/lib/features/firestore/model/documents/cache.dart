import "package:canacache/features/firestore/model/collections/cache_items.dart";
import "package:canacache/features/firestore/model/collections/caches.dart";
import "package:canacache/features/firestore/model/document_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A landmark or other important location
class Cache extends DocumentModel<Cache> {
  // fields
  Timestamp createdAt;
  String name;
  GeoPoint position;
  String uid;
  Timestamp updatedAt;

  Cache({
    String? id,
    Timestamp? createdAt,
    required this.name,
    required this.position,
    required this.uid,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now(),
        super(Caches().getDocumentReference(id));

  Cache.fromMap(Map<String, dynamic> map, super.ref)
      : createdAt = map["createdAt"],
        name = map["name"],
        position = map["position"],
        uid = map["uid"],
        updatedAt = map["updatedAt"];

  @override
  Map<String, dynamic> toMap() => {
        "createdAt": createdAt,
        "name": name,
        "position": position,
        "uid": uid,
        "updatedAt": Timestamp.now(), // change updatedAt on write
      };

  @override
  Future<void> delete() async {
    // get the actual objects, not just the references, in case they also have subcollections to delete
    for (final item in await CacheItems(ref).getObjects()) {
      await item.delete();
    }
    return super.delete();
  }

  // TODO: implement this
  // static List<Cache> getNearbyCaches(User user) {};
}
