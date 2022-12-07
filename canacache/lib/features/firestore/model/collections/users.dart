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

  /// Get a reference to the current user.
  ///
  /// Throws if not logged in.
  DocumentReference<CanaUser> getCurrentUserReference() {
    final id = FirebaseAuth.instance.currentUser!.uid;
    return getDocumentReference(id);
  }

  /// Get or create a User object for the current user.
  ///
  /// Throws if not logged in.
  Future<CanaUser> getCurrentUser() async {
    final ref = getCurrentUserReference();

    final existingUser = await getObjectFromRef(ref);
    if (existingUser != null) return existingUser;

    final newUser = CanaUser.withRef(ref: ref);
    await newUser.create();
    return newUser;
  }

  /// Stream the user object for the current user.
  ///
  /// Throws if not logged in or if the object doesn't exist. Sorry. I'm tired.
  Stream<CanaUser> streamCurrentUser() {
    return streamObject(FirebaseAuth.instance.currentUser!.uid)
        .map((user) => user!);
  }
}
