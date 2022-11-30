import "package:canacache/features/firestore/model/exceptions.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

abstract class DocumentModel<Self extends DocumentModel<Self>> {
  late DocumentReference<Self> ref;

  /// Instance-level getter for the class's static Serializer object.
  ///
  /// Lets you pass just a class instance without also passing its serializer.
  Serializer<Self> get serializer_; // _ is because dart said i had to

  DocumentModel(this.ref);

  DocumentModel._(); // so subcollection can late-initialize ref itself

  DocumentModel.fromId(String? id) {
    ref = getDocumentReference(serializer_, id);
  }

  // CUD (no read) methods
  // these are here because they may need to be overridden
  // eg. for deleting models with subcollections

  /// Insert this document into Firestore.
  ///
  /// Throws [AlreadyExistsException] if the document already exists.
  Future<void> create() async {
    final snapshot = await ref.get();
    if (snapshot.exists) throw AlreadyExistsException();

    return ref.set(this as Self);
  }

  Future<void> update() => ref.set(this as Self);

  Future<void> delete() => ref.delete();
}

abstract class SubcollectionDocumentModel<
    Self extends SubcollectionDocumentModel<Self, Parent>,
    Parent extends DocumentModel<Parent>> extends DocumentModel<Self> {
  @override
  SubcollectionSerializer<Self, Parent> get serializer_;

  SubcollectionDocumentModel(super.ref);

  SubcollectionDocumentModel.fromId(
    String? id,
    DocumentReference<Parent> parent,
  ) : super._() {
    ref = getDocumentReference(serializer_, id, parent);
  }
}
