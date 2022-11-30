import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/model/firestore_database.dart";
import "package:canacache/features/firestore/view/cache_list.dart";
import "package:flutter/material.dart";

class CacheListPage extends StatefulWidget {
  const CacheListPage({super.key});

  @override
  State<CacheListPage> createState() => _CacheListPageState();
}

class _CacheListPageState extends State<CacheListPage> {
  @override
  Widget build(BuildContext context) {
    return CanaScaffold(
      title: "Caches",
      body: StreamBuilder(
        stream: streamObjects(Cache.serializer),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return CacheList(caches: snapshot.data!);
        },
      ),
    );
  }
}
