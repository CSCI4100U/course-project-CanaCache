import "dart:convert";

import "package:canacache/features/firestore/model/cache.dart";
import "package:canacache/features/firestore/model/item.dart";
import "package:canacache/features/firestore/model/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class CanaFirestore {
  static String userID = "";

  // easier to just call CanaFirestore.getCollection("caches") for example
  static CollectionReference<Map<String, dynamic>> getCollection(String name) {
    return FirebaseFirestore.instance.collection(name);
  }

  // this is the worst possible code ever written
  // optional: figure out how to template EVERYTHING

  // caches
  static Future<Cache?>? getCache(String id) async {
    return getCollection("caches")
        .doc(id)
        .withConverter<Cache>(
          fromFirestore: (snapshot, _) =>
              Cache.fromJson(snapshot.data()!, snapshot.reference),
          toFirestore: (model, _) => json.decode(cacheToJson(model)),
        )
        .get()
        .then((data) => data.data())
        .catchError((e) => null);
  }

  static Future<List<Cache>>? getCaches() async {
    return getCollection("caches").get().then(
          (value) => value.docs
              .map((cache) => Cache.fromJson(cache.data(), cache.reference))
              .toList(),
        );
  }

  static Future<void> createCache(Cache cache) async {
    return await getCollection("caches").doc().set(cache.toJson());
  }

  static Future<void> updateCache(Cache cache) async {
    return await getCollection("caches").doc(cache.id).update(cache.toJson());
  }

  static Future<void> deleteCache(Cache cache) async {
    return await getCollection("caches").doc(cache.id).delete();
  }

  // items
  static Future<Item?>? getItem(String id) async {
    return getCollection("items")
        .doc(id)
        .withConverter<Item>(
          fromFirestore: (snapshot, _) =>
              Item.fromJson(snapshot.data()!, snapshot.reference),
          toFirestore: (model, _) => json.decode(itemToJson(model)),
        )
        .get()
        .then((data) => data.data())
        .catchError((e) => null);
  }

  static Future<List<Item>>? getItems() async {
    return getCollection("items").get().then(
          (value) => value.docs
              .map((item) => Item.fromJson(item.data(), item.reference))
              .toList(),
        );
  }

  static Future<void> createItem(Item item) async {
    return await getCollection("items").doc().set(item.toJson());
  }

  static Future<void> updateItem(Item item) async {
    return await getCollection("items").doc(item.id).update(item.toJson());
  }

  static Future<void> deleteItem(Item item) async {
    return await getCollection("items").doc(item.id).delete();
  }

  // users
  static Future<User?>? getUser(String id) async {
    return getCollection("users")
        .doc(id)
        .withConverter<User>(
          fromFirestore: (snapshot, _) =>
              User.fromJson(snapshot.data()!, snapshot.reference),
          toFirestore: (model, _) => json.decode(userToJson(model)),
        )
        .get()
        .then((data) => data.data())
        .catchError((e) => null);
  }

  static Future<List<User>>? getUsers() async {
    return getCollection("users").get().then(
          (value) => value.docs
              .map((user) => User.fromJson(user.data(), user.reference))
              .toList(),
        );
  }

  static Future<void> createUser(User user) async {
    return await getCollection("users").doc().set(user.toJson());
  }

  static Future<void> updateUser(User user) async {
    return await getCollection("users").doc(user.id).update(user.toJson());
  }

  static Future<void> deleteUser(User user) async {
    return await getCollection("users").doc(user.id).delete();
  }
}
