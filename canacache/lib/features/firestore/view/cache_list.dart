import "package:canacache/common/utils/formatting_extensions.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/widgets/scaffold.dart";
import "package:canacache/features/firestore/controller/cache_list_controller.dart";
import "package:flutter/material.dart";

class CacheList extends StatefulWidget {
  const CacheList({Key? key}) : super(key: key);

  @override
  State<CacheList> createState() => CacheListState();
}

class CacheListState extends ViewState<CacheList, CacheListController> {
  CacheListState() : super(CacheListController());

  @override
  Widget build(BuildContext context) {
    return CanaScaffold(
      title: "Available Caches",
      body: StreamBuilder(
        stream: con.getCacheStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final caches = snapshot.data!;
          return ListView.builder(
            itemCount: caches.length,
            itemBuilder: (context, index) {
              final cache = caches[index];
              return ListTile(
                title: Text(cache.name),
                subtitle: Text(cache.position.toLatLng()),
              );
            },
          );
        },
      ),
    );
  }
}
