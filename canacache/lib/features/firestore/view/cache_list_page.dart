import "package:canacache/features/firestore/model/collections/caches.dart";
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
    return StreamBuilder(
      stream: Caches().streamObjects(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return CacheList(caches: snapshot.data!);
      },
    );
  }
}
