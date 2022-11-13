import "package:canacache/features/services/model/cache.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class CanaFirestore {
  static String userID = "";

  CanaFirestore();

  // easier to just call CanaFirestore.getCollection("caches") for example
  static CollectionReference<Map<String, dynamic>> getCollection(String name) {
    return FirebaseFirestore.instance.collection(name);
  }

  // TODO: queries

  Future<void> insertCache(Cache cache) async {
    // getCollection('caches')
  }
}