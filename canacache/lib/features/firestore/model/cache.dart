import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:canacache/features/firestore/model/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A landmark or other important location
class Cache implements DocumentModel {
  static final serializer = Serializer<Cache>(
    fromJson: Cache.fromJson,
    toJson: (cache) => cache.toJson(),
    collection: "caches",
  );

  @override
  Serializer<Cache> get serializer_ => serializer;

  @override
  String? id;

  Timestamp createdAt;
  DocumentReference<User> createdBy;
  String name;
  GeoPoint position;
  Timestamp updatedAt;

  /// Create a [Cache] instance
  Cache({
    this.id,
    Timestamp? createdAt,
    required this.createdBy,
    required this.name,
    required this.position,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  /// Create [Cache] instance from Firebase document
  Cache.fromJson(Map<String, dynamic> json, this.id)
      : createdAt = json["createdAt"],
        createdBy = convertReference(
          User.serializer,
          json["createdBy"],
        ),
        name = json["name"],
        position = json["position"],
        updatedAt = json["updatedAt"];

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "createdBy": createdBy,
        "name": name,
        "position": position,
        "updatedAt": Timestamp.now(), // change updatedAt on write
      };

  // TODO: implement this
  // static List<Cache> getNearbyCaches(User user) {};
}
