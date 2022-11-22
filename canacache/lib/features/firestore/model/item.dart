import "package:canacache/features/firestore/model/cache.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:canacache/features/firestore/model/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// Represents an item left in a cache
class Item implements DocumentModel {
  static final serializer = Serializer<Item>(
    fromJson: Item.fromJson,
    toJson: (item) => item.toJson(),
    collection: "items",
  );

  @override
  Serializer<Item> get serializer_ => serializer;

  @override
  String? id;

  Timestamp addedAt;
  DocumentReference<User> addedBy;
  DocumentReference<Cache> cache;
  String name;

  /// Create [Item] instance.
  Item({
    this.id,
    Timestamp? addedAt,
    required this.addedBy,
    required this.cache,
    required this.name,
  }) : addedAt = addedAt ?? Timestamp.now();

  /// Create [Item] instance from Firebase document
  Item.fromJson(Map<String, dynamic> json, this.id)
      : addedAt = json["addedAt"],
        addedBy = convertReference(
          User.serializer,
          json["addedBy"],
        ),
        cache = convertReference(
          Cache.serializer,
          json["cache"],
        ),
        name = json["name"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "addedAt": addedAt,
        "addedBy": addedBy,
      };
}
