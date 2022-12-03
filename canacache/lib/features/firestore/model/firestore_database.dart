import "package:canacache/features/firestore/model/document_model.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

CollectionReference<T> getCollection<T extends DocumentModel<T>>(
  Serializer<T> serializer, [
  DocumentReference? parent,
]) {
  CollectionReference<Map<String, dynamic>> collection;

  // i really don't like this. this should be represented in the type system.
  if (serializer is SubcollectionSerializer) {
    if (parent == null) throw ArgumentError("Missing parent"); // orphan moment
    collection = parent.collection(serializer.collection);
  } else {
    // and it's not a subcollection
    if (parent != null) throw ArgumentError("Unexpected parent");
    collection = FirebaseFirestore.instance.collection(serializer.collection);
  }

  return collection.withConverter(
    fromFirestore: serializer.fromFirestore,
    toFirestore: serializer.toFirestore,
  );
}

DocumentReference<T> getDocumentReference<T extends DocumentModel<T>>(
  Serializer<T> serializer,
  String? id, [
  DocumentReference? parent,
]) {
  return getCollection(serializer, parent).doc(id);
}

Future<List<T>> getObjects<T extends DocumentModel<T>>(
  Serializer<T> serializer, [
  DocumentReference? parent,
]) async {
  final snapshot = await getCollection(serializer, parent).get();
  return snapshot.docs.map((doc) => doc.data()).toList();
}

Stream<List<T>> streamObjects<T extends DocumentModel<T>>(
  Serializer<T> serializer, [
  DocumentReference? parent,
]) {
  return getCollection(serializer, parent)
      .snapshots()
      .map((s) => s.docs.map((d) => d.data()).toList());
}

Future<T?> getObject<T extends DocumentModel<T>>(
  Serializer<T> serializer,
  String id, [
  DocumentReference? parent,
]) async {
  final snapshot = await getDocumentReference(serializer, id, parent).get();
  return snapshot.data();
}

/// Get or create a User object for the current user.
///
/// Throws if not logged in.
Future<CanaUser> getCurrentUser() async {
  final id = FirebaseAuth.instance.currentUser!.uid;

  final existingUser = await getObject(CanaUser.serializer, id);
  if (existingUser != null) return existingUser;

  final newUser = CanaUser(id: id);
  await newUser.create();
  return newUser;
}

DocumentReference<T> convertDocumentReference<T extends DocumentModel<T>>(
  Serializer<T> serializer,
  DocumentReference reference,
) {
  return reference.withConverter(
    fromFirestore: serializer.fromFirestore,
    toFirestore: serializer.toFirestore,
  );
}

Future<List<T>> getFromReferences<T extends DocumentModel<T>>(
  List<DocumentReference<T>> references,
) async {
  final List<T> objects = [];
  for (final reference in references) {
    final snapshot = await reference.get();
    if (snapshot.exists) objects.add(snapshot.data()!);
  }
  return objects;
}
