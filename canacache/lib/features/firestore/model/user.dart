import "package:canacache/features/firestore/model/cache.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A user participating in CanaCache
class User implements DocumentModel {
  static final serializer = Serializer<User>(
    fromJson: User.fromJson,
    toJson: (user) => user.toJson(),
    collection: "users",
  );

  @override
  Serializer<User> get serializer_ => serializer;

  @override
  String id;

  GeoPoint position;
  List<DocumentReference<Cache>>? visitedCaches;

  /// Create [User] instance.
  User({
    required this.id,
    required this.position,
    this.visitedCaches,
  });

  /// Create [User] instance from Firebase document
  User.fromJson(Map<String, dynamic> json, this.id)
      : position = json["position"],
        visitedCaches = json["visitedCaches"]?.map(
          (r) => convertReference(serializer, r),
        );

  /// Create Firebase document from [User]
  Map<String, dynamic> toJson() => {
        "position": position,
        "visitedCaches": visitedCaches,
      };
}
