import 'package:canacache/features/services/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an item left in a cache
class Item {
  String name;
  User addedBy;
  Timestamp addedAt;
  String? id;

  /// Create [Item] instance.
  Item({required this.name, required this.addedAt, required this.addedBy, this.id});

  factory Item.fromJson(Map<String, dynamic> json, DocumentReference reference) =>
      Item(
        name: json["name"],
        addedAt: json["addedAt"],
        addedBy: json["addedBy"],
        id: reference.id,
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "addedAt": addedAt,
    "addedBy": addedBy,
    "id": id,
  };
}