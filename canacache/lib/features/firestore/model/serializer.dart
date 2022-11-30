import "package:canacache/features/firestore/model/document_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A convenient way to pass around json conversion functions.
class Serializer<T extends DocumentModel<T>> {
  Serializer({
    required this.fromJson,
    required this.toJson,
    required this.collection,
  });

  final T Function(Map<String, dynamic> json, DocumentReference<T> ref)
      fromJson;
  final Map<String, Object?> Function(T) toJson;
  final String collection;

  T fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return fromJson(
      snapshot.data()!,
      snapshot.reference.withConverter(
        fromFirestore: fromFirestore,
        toFirestore: toFirestore,
      ),
    );
  }

  Map<String, Object?> toFirestore(T item, SetOptions? options) {
    return toJson(item);
  }
}

class SubcollectionSerializer<T extends SubcollectionDocumentModel<T, Parent>,
    Parent extends DocumentModel<Parent>> extends Serializer<T> {
  SubcollectionSerializer({
    required super.fromJson,
    required super.toJson,
    required super.collection,
  });
}
