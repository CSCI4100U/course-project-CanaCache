import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

abstract class DocumentModel {
  String? get id; // only a getter so implementers can make id non-null

  /// Avoids having to pass the serializer along with an instance.
  Serializer<DocumentModel> get serializer_; // _ is because dart said i had to
}

class CanaFirestore {
  static String userID = "";

  static CollectionReference<T> getCollection<T extends DocumentModel>(
    Serializer<T> serializer,
  ) {
    print(serializer.collection);
    return FirebaseFirestore.instance
        .collection(serializer.collection)
        .withConverter<T>(
          fromFirestore: serializer.fromFirestore,
          toFirestore: serializer.toFirestore,
        );
  }

  static Future<List<T>> getObjects<T extends DocumentModel>(
    Serializer<T> serializer,
  ) async {
    final snapshot = await getCollection(serializer).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Stream<List<T>> streamObjects<T extends DocumentModel>(
    Serializer<T> serializer,
  ) {
    return getCollection(serializer)
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  static Future<void> createObject<T extends DocumentModel>(T object) {
    return getCollection(object.serializer_).doc(object.id).set(object);
  }

  static Future<void> updateObject<T extends DocumentModel>(T object) {
    return getCollection(object.serializer_).doc(object.id!).set(object);
  }

  static Future<void> deleteObject<T extends DocumentModel>(T object) {
    return getCollection(object.serializer_).doc(object.id!).delete();
  }

  static DocumentReference<T> convertReference<T extends DocumentModel>(
    Serializer<T> serializer,
    DocumentReference reference,
  ) {
    return reference.withConverter(
      fromFirestore: serializer.fromFirestore,
      toFirestore: serializer.toFirestore,
    );
  }

  static Future<List<T>> getFromReferences<T extends DocumentModel>(
    List<DocumentReference<T>> references,
  ) async {
    final List<T> objects = [];
    for (final reference in references) {
      final snapshot = await reference.get();
      if (snapshot.exists) objects.add(snapshot.data()!);
    }
    return objects;
  }
}
