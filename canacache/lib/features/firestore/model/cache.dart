import "dart:convert";
import "package:cloud_firestore/cloud_firestore.dart";

String cacheToJson(Cache cache) => json.encode(cache.toJson());

/// A landmark or other important location
class Cache {
  GeoPoint location;
  String name;
  String? id;
  List<DocumentReference>? items;
  List<DocumentReference>? recentVisitors;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  /// Creates a [Cache] instance
  Cache({
    required this.name,
    required this.location,
    this.id,
    this.items,
    this.recentVisitors,
    this.createdAt,
    this.updatedAt,
  });

  /// constructor from Firebase DocumentReference
  @override
  factory Cache.fromJson(
    Map<String, dynamic> map,
    DocumentReference reference,
  ) =>
      Cache(
        id: reference.id,
        location: map["location"],
        name: map["name"],
        items: map["items"],
        recentVisitors: map["recentVisitors"],
        createdAt: map["createdAt"],
        updatedAt: map["updatedAt"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "location": location,
        "name": name,
        "items": items,
        "recentVisitors": recentVisitors,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  // TODO: implement this
  // static List<Cache> getNearbyCaches(User user) {};
}
