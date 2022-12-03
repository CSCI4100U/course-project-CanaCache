import "package:canacache/features/firestore/model/exceptions.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// Model of a Firestore document.
///
/// Subclasses should implement a `fromMap(Map<String, dynamic> map, super.ref)` constructor.
abstract class DocumentModel<Self extends DocumentModel<Self>> {
  final DocumentReference<Self> ref;

  DocumentModel(this.ref);

  // abstract methods
  Map<String, Object?> toMap();

  // CUD methods (read is in CollectionModel)
  // these are here because they may need to be overridden
  // eg. for deleting models with subcollections

  /// Insert this document into Firestore.
  ///
  /// Throws [AlreadyExistsException] if the document already exists.
  Future<void> create() async {
    final snapshot = await ref.get();
    if (snapshot.exists) throw AlreadyExistsException();

    await ref.set(this as Self);
  }

  Future<void> update() => ref.set(this as Self);

  Future<void> delete() => ref.delete();
}
