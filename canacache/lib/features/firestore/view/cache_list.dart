import "package:canacache/common/utils/formatting_extensions.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/controller/cache_list_controller.dart";
import "package:canacache/features/firestore/model/collections/cache_items.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/view/item_list.dart";
import "package:flutter/material.dart";

// this is in its own widget so that opening a cache doesn't refresh the stream
// which was causing a loading indicator to briefly flicker
class CacheList extends StatefulWidget {
  final List<Cache> caches;

  const CacheList({super.key, required this.caches});

  @override
  State<CacheList> createState() => CacheListState();
}

class CacheListState extends ViewState<CacheList, CacheListController> {
  CacheListState() : super(CacheListController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.caches.length,
      itemBuilder: (context, index) {
        final cache = widget.caches[index];
        final isSelected = con.selectedIndex == index;

        final tile = ListTile(
          title: Text(cache.name),
          subtitle: Text(cache.position.toLatLng()),
          onTap: () => con.onTap(index),
          trailing: isSelected
              ? const Icon(Icons.arrow_drop_down)
              : const Icon(Icons.arrow_right),
        );

        if (!isSelected) return tile;

        return Column(
          children: [
            tile,
            StreamBuilder(
              stream: CacheItems(cache.ref).streamObjects(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Error.throwWithStackTrace(
                    snapshot.error!,
                    snapshot.stackTrace!,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LinearProgressIndicator());
                }

                return ItemList(items: snapshot.data!);
              },
            ),
          ],
        );
      },
    );
  }
}
