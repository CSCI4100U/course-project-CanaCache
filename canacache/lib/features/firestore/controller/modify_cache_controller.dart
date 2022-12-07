import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/features/firestore/model/collections/users.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/view/modify_cache/modify_cache_page.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class ModifyCacheController extends Controller<ModifyCache, ModifyCacheState> {
  final formKey = GlobalKey<FormState>();
  Cache? cache;
  String name = "";

  @override
  void initState() {
    super.initState();
    if (state.widget.args.cache != null) {
      cache = state.widget.args.cache;
      name = cache!.name;
    }
  }

  void close() {
    Navigator.pushNamedAndRemoveUntil(
      state.context,
      CanaRoute.signIn.name,
      (_) => false,
    );
  }

  void saveCacheAndClose() async {
    if (state.widget.args.cache == null) {
      // create new cache, with coordinates
      GeoPoint geoPoint = GeoPoint(
        state.widget.args.coordinates!.latitude,
        state.widget.args.coordinates!.longitude,
      );

      // dart yells at me if i don't await/then
      await Users().getCurrentUser().then(
            (user) => cache = Cache(
              name: name,
              position: geoPoint,
              uid: user.ref.id,
            ),
          );
    } else {
      cache!.name = name;
    }

    await cache!.update().then((_) => close());
  }
}
