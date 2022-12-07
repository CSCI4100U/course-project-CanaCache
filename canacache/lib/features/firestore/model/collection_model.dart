import "package:canacache/features/firestore/model/document_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";

typedef RawDocumentReference = DocumentReference<Map<String, dynamic>>;
typedef RawCollectionReference = CollectionReference<Map<String, dynamic>>;

abstract class CollectionModel<Doc extends DocumentModel<Doc>> {
  // abstract properties
  String get collectionName;

  // abstract methods
  Doc fromMap(Map<String, dynamic> map, DocumentReference<Doc> ref);

  // converters

  Doc fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return fromMap(
      snapshot.data()!,
      convertDocumentReference(snapshot.reference),
    );
  }

  Map<String, Object?> toFirestore(Doc doc, SetOptions? options) {
    return doc.toMap();
  }

  DocumentReference<Doc> convertDocumentReference(RawDocumentReference ref) {
    return ref.withConverter(
      fromFirestore: fromFirestore,
      toFirestore: toFirestore,
    );
  }

  CollectionReference<Doc> convertCollectionReference(
    RawCollectionReference ref,
  ) {
    return ref.withConverter(
      fromFirestore: fromFirestore,
      toFirestore: toFirestore,
    );
  }

  List<DocumentReference<Doc>> convertDocumentReferences(
    List<RawDocumentReference> refs,
  ) {
    return refs.map((ref) => convertDocumentReference(ref)).toList();
  }

  List<CollectionReference<Doc>> convertCollectionReferences(
    List<RawCollectionReference> refs,
  ) {
    return refs.map((ref) => convertCollectionReference(ref)).toList();
  }

  // getters

  CollectionReference<Doc> getCollection() {
    return convertCollectionReference(
      FirebaseFirestore.instance.collection(collectionName),
    );
  }

  DocumentReference<Doc> getDocumentReference(String? id) {
    return getCollection().doc(id);
  }

  Future<List<DocumentReference<Doc>>> getDocumentReferences([
    GetOptions? options,
  ]) async {
    final snapshot = await getCollection().get(options);
    return snapshot.docs.map((doc) => doc.reference).toList();
  }

  Future<Doc?> getObjectFromRef(DocumentReference<Doc> ref) async {
    final snapshot = await ref.get();
    return snapshot.data();
  }

  Future<Doc?> getObject(String id) async {
    return getObjectFromRef(getDocumentReference(id));
  }

  Future<List<Doc>> getObjects([GetOptions? options]) async {
    final snapshot = await getCollection().get(options);
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Stream<Doc?> streamObject(String id, {bool includeMetadataChanges = false}) {
    return getDocumentReference(id)
        .snapshots(includeMetadataChanges: includeMetadataChanges)
        .map((s) => s.data());
  }

  Stream<List<Doc>> streamObjects({bool includeMetadataChanges = false}) {
    return getCollection()
        .snapshots(includeMetadataChanges: includeMetadataChanges)
        .map((s) => s.docs.map((d) => d.data()).toList());
  }
}

abstract class SubcollectionModel<Doc extends DocumentModel<Doc>,
    Parent extends DocumentModel<Parent>> extends CollectionModel<Doc> {
  final DocumentReference<Parent> parentRef;

  SubcollectionModel(this.parentRef);

  @override
  CollectionReference<Doc> getCollection() {
    return convertCollectionReference(parentRef.collection(collectionName));
  }

  Future<Parent?> getParent() async {
    final snapshot = await parentRef.get();
    return snapshot.data();
  }
}
