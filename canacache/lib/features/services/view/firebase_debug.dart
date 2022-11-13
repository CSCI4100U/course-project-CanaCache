import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/services/controller/firebase_debug_controller.dart";
import "package:canacache/features/services/controller/firestore_database.dart";
import "package:canacache/features/services/model/cache.dart";
import "package:canacache/features/services/model/item.dart";
import "package:canacache/features/services/model/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// Debug view to test querying from Firestore
class FirebaseDebug extends StatefulWidget {
  const FirebaseDebug({Key? key}) : super(key: key);

  @override
  State<FirebaseDebug> createState() => FirebaseDebugState();
}

class FirebaseDebugState
    extends ViewState<FirebaseDebug, FirebaseDebugController> {
  FirebaseDebugState() : super(FirebaseDebugController());

  @override
  Widget build(BuildContext context) {
    // CanaTheme theme = Provider.of<SettingsProvider>(context).theme;

    return CanaScaffold(
      // three containers - cache info, item info, user info
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot> (
            stream: CanaFirestore.getCollection("caches").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError) {
                if(kDebugMode) {
                  print("snapshot error");
               }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<DocumentSnapshot> cacheList = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: cacheList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildCacheCard(
                        Cache(
                          name: cacheList[index].get("name"),
                          location: cacheList[index].get("location"),
                          id: cacheList[index].id,
                        ),
                    );
                  },
              );
            },
          ),

          // item
          StreamBuilder<QuerySnapshot> (
            stream: CanaFirestore.getCollection("items").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError) {
                if(kDebugMode) {
                  print("snapshot error");
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<DocumentSnapshot> itemList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildItemCard(
                    Item(
                      name: itemList[index].get("name"),
                      addedBy: itemList[index].get("addedBy"),
                      addedAt: itemList[index].get("addedAt"),
                    ),
                  );
                },
              );
            },
          ),

          // user
          StreamBuilder<QuerySnapshot> (
            stream: CanaFirestore.getCollection("users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError) {
                if(kDebugMode) {
                  print("snapshot error");
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<DocumentSnapshot> usersList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildUserCard(
                    User(
                      id: usersList[index].id,
                      position: usersList[index].get("position"),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget buildCacheCard(Cache cache) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
        children: [
          // location name
          Text(
            cache.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          // cache ID
          Text(
            "ID: ${cache.id}",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          // coordinates
          Text(
            "${cache.location.latitude}, ${cache.location.longitude}",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
    ),
  );
}

Widget buildUserCard(User user) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        // user ID
        Text(
          "User ID: ${user.id}",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // location
        Text(
          "Position: ${user.position.latitude}, ${user.position.longitude}",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget buildItemCard(Item item) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        // user ID
        Text(
          item.name,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // location
        Text(
          "Added at ${item.addedAt}",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}