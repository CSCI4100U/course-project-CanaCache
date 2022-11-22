import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

abstract class DocumentModel {
  String? get id; // only a getter so implementers can make id non-null

  /// Avoids having to pass the serializer along with an instance.
  Serializer<DocumentModel> get serializer_; // _ is because dart said i had to
}

CollectionReference<T> getCollection<T extends DocumentModel>(
  Serializer<T> serializer,
) {
  return FirebaseFirestore.instance
      .collection(serializer.collection)
      .withConverter<T>(
        fromFirestore: serializer.fromFirestore,
        toFirestore: serializer.toFirestore,
      );
}

Future<List<T>> getObjects<T extends DocumentModel>(
  Serializer<T> serializer,
) async {
  final snapshot = await getCollection(serializer).get();
  return snapshot.docs.map((doc) => doc.data()).toList();
}

Stream<List<T>> streamObjects<T extends DocumentModel>(
  Serializer<T> serializer,
) {
  return getCollection(serializer)
      .snapshots()
      .map((s) => s.docs.map((d) => d.data()).toList());
}

Future<void> createObject<T extends DocumentModel>(T object) {
  return getCollection(object.serializer_).doc(object.id).set(object);
}

Future<void> updateObject<T extends DocumentModel>(T object) {
  return getCollection(object.serializer_).doc(object.id!).set(object);
}

Future<void> deleteObject<T extends DocumentModel>(T object) {
  return getCollection(object.serializer_).doc(object.id!).delete();
}

DocumentReference<T> convertReference<T extends DocumentModel>(
  Serializer<T> serializer,
  DocumentReference reference,
) {
  return reference.withConverter(
    fromFirestore: serializer.fromFirestore,
    toFirestore: serializer.toFirestore,
  );
}

Future<List<T>> getFromReferences<T extends DocumentModel>(
  List<DocumentReference<T>> references,
) async {
  final List<T> objects = [];
  for (final reference in references) {
    final snapshot = await reference.get();
    if (snapshot.exists) objects.add(snapshot.data()!);
  }
  return objects;
}
