import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/features/firestore/model/collections/caches.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list.dart";
import "package:flutter/material.dart";

class CacheListPage extends StatelessWidget {
  const CacheListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CanaStreamBuilder(
      stream: Caches().streamObjects(),
      builder: (context, caches) => CacheList(caches: caches),
    );
  }
}
