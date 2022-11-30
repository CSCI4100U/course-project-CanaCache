import "package:canacache/features/firestore/model/document_model.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// Represents an item left in a cache
class Item extends SubcollectionDocumentModel<Item, Cache> {
  static final serializer = SubcollectionSerializer<Item, Cache>(
    fromJson: Item.fromJson,
    toJson: (item) => item.toJson(),
    collection: "items",
  );
  @override
  SubcollectionSerializer<Item, Cache> get serializer_ => serializer;

  // fields
  Timestamp addedAt;
  String name;
  String uid;

  /// Create [Item] instance.
  Item({
    String? id,
    required DocumentReference<Cache> cache,
    Timestamp? addedAt,
    required this.name,
    required this.uid,
  })  : addedAt = addedAt ?? Timestamp.now(),
        super.fromId(id, cache);

  /// Create [Item] instance from Firebase document
  Item.fromJson(Map<String, dynamic> json, super.ref)
      : addedAt = json["addedAt"],
        name = json["name"],
        uid = json["uid"];

  Map<String, dynamic> toJson() => {
        "addedAt": addedAt,
        "name": name,
        "uid": uid,
      };
}
