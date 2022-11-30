import "package:canacache/features/firestore/model/document_model.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/model/serializer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// A user participating in CanaCache
class CanaUser extends DocumentModel<CanaUser> {
  static final serializer = Serializer(
    fromJson: CanaUser.fromJson,
    toJson: (user) => user.toJson(),
    collection: "users",
  );
  @override
  Serializer<CanaUser> get serializer_ => serializer;

  // fields
  List<DocumentReference<Cache>> visitedCaches;

  /// Create [CanaUser] instance.
  CanaUser({
    required String id,
    this.visitedCaches = const [],
  }) : super.fromId(id);

  /// Create [CanaUser] instance from Firebase document
  CanaUser.fromJson(Map<String, dynamic> json, super.ref)
      : visitedCaches = json["visitedCaches"].map(
          (r) => convertDocumentReference(serializer, r),
        );

  /// Create Firebase document from [CanaUser]
  Map<String, dynamic> toJson() => {
        "visitedCaches": visitedCaches,
      };
}
