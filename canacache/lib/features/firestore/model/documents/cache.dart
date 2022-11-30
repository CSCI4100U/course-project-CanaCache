import "package:canacache/features/firestore/model/document_model.dart";
import "package:canacache/features/firestore/model/documents/item.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A landmark or other important location
class Cache extends DocumentModel<Cache> {
  static final serializer = Serializer(
    fromJson: Cache.fromJson,
    toJson: (cache) => cache.toJson(),
    collection: "caches",
  );
  @override
  Serializer<Cache> get serializer_ => serializer;

  // fields
  Timestamp createdAt;
  String name;
  GeoPoint position;
  String uid;
  Timestamp updatedAt;

  /// Create a [Cache] instance
  Cache({
    String? id,
    Timestamp? createdAt,
    required this.name,
    required this.position,
    Timestamp? updatedAt,
    required this.uid,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now(),
        super.fromId(id);

  /// Create [Cache] instance from Firebase document
  Cache.fromJson(Map<String, dynamic> json, super.ref)
      : createdAt = json["createdAt"],
        name = json["name"],
        position = json["position"],
        uid = json["uid"],
        updatedAt = json["updatedAt"];

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "name": name,
        "position": position,
        "uid": uid,
        "updatedAt": Timestamp.now(), // change updatedAt on write
      };

  @override
  Future<void> delete() async {
    for (final item in await getObjects(Item.serializer, ref)) {
      await item.delete();
    }
    return super.delete();
  }

  // TODO: implement this
  // static List<Cache> getNearbyCaches(User user) {};
}
