import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A convenient way to pass around json conversion functions.
class Serializer<T extends DocumentModel> {
  Serializer({
    required this.fromJson,
    required this.toJson,
    required this.collection,
  });

  final T Function(Map<String, dynamic> json, String id) fromJson;
  final Map<String, Object?> Function(T) toJson;
  final String collection;

  T fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return fromJson(snapshot.data()!, snapshot.id);
  }

  Map<String, Object?> toFirestore(T item, SetOptions? options) {
    return toJson(item);
  }
}
