import "package:canacache/features/firestore/model/collection_model.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class Users extends CollectionModel<CanaUser> {
  @override
  final collectionName = "users";

  @override
  CanaUser fromMap(Map<String, dynamic> map, DocumentReference<CanaUser> ref) {
    return CanaUser.fromMap(map, ref);
  }

  /// Get or create a User object for the current user.
  ///
  /// Throws if not logged in.
  Future<CanaUser> getCurrentUser() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final ref = getDocumentReference(id);

    final existingUser = await getObjectFromRef(ref);
    if (existingUser != null) return existingUser;

    final newUser = CanaUser.withRef(ref: ref);
    await newUser.create();
    return newUser;
  }
}
