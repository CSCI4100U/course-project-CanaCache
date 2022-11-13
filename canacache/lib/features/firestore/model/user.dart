import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:canacache/features/firestore/model/cache.dart";

String userToJson(User user) => json.encode(user.toJson());

/// A user participating in CanaCache
class User {
  String id;

  /// UID taken from Firebase auth
  GeoPoint position;

  /// [Geopoint] representing the user's current location
  List<DocumentReference>? cachesCreated;

  /// A list of [Cache]s the [User] created
  List<DocumentReference>? recentCaches;

  /// A list of recent [Cache]s visited by the [User]

  /// Create [User] instance.
  User({
    required this.id,
    required this.position,
    this.cachesCreated,
    this.recentCaches,
  });

  /// Create [User] instance from Firebase snapshot
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "cachesCreated": cachesCreated,
        "recentCaches": recentCaches,
      };
}
