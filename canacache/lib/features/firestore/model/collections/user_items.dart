import "package:canacache/features/firestore/model/collection_model.dart";
import "package:canacache/features/firestore/model/collections/users.dart";
import "package:canacache/features/firestore/model/documents/item.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class UserItems extends SubcollectionModel<Item, CanaUser> {
  @override
  final collectionName = "items";

  UserItems(super.parentRef);

  UserItems.forCurrentUser() : super(Users().getCurrentUserReference());

  @override
  Item fromMap(Map<String, dynamic> map, DocumentReference<Item> ref) {
    return Item.fromMap(map, ref);
  }
}
