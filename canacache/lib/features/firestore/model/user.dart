import "dart:convert";

import "package:canacache/features/firestore/model/cache.dart";
import "package:cloud_firestore/cloud_firestore.dart";

String userToJson(User user) => json.encode(user.toJson());

/// A user participating in CanaCache
class User {
  /// UID taken from Firebase auth
  String id;

  /// [Geopoint] representing the user's current location
  GeoPoint position;

  /// A list of [Cache]s the [User] created
  List<DocumentReference>? cachesCreated;

  /// A list of recent [Cache]s visited by the [User]
  List<DocumentReference>? recentCaches;

  /// Create [User] instance.
  User({
    required this.id,
    required this.position,
    this.cachesCreated,
    this.recentCaches,
  });

  /// Create [User] instance from Firebase document
  factory User.fromJson(
    Map<String, dynamic> json,
    DocumentReference reference,
  ) =>
      User(
        id: reference.id,
        position: json["position"],
        cachesCreated: json["cachesCreated"],
        recentCaches: json["recentCaches"],
      );

  /// Create Firebase document from [User]
  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "cachesCreated": cachesCreated,
        "recentCaches": recentCaches,
      };
}
