import "package:canacache/features/firestore/model/collection_model.dart";
import "package:canacache/features/firestore/model/document_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";

/// Represents an item left in a cache or held by a user
class Item extends DocumentModel<Item> {
  // fields
  Timestamp addedAt;
  String name;
  String uid;

  Item({
    String? id,
    required CollectionModel<Item> collectionModel,
    Timestamp? addedAt,
    required this.name,
    required this.uid,
  })  : addedAt = addedAt ?? Timestamp.now(),
        super(collectionModel.getDocumentReference(id));

  Item.fromMap(Map<String, dynamic> map, super.ref)
      : addedAt = map["addedAt"],
        name = map["name"],
        uid = map["uid"];

  @override
  Map<String, dynamic> toMap() => {
        "addedAt": addedAt,
        "name": name,
        "uid": uid,
      };
}
