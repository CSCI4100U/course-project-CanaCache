import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/common/utils/extensions.dart";
import "package:canacache/common/utils/geo.dart";
import "package:canacache/features/firestore/model/collections/caches.dart";
import "package:canacache/features/firestore/model/collections/users.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list.dart";
import "package:canacache/features/stats_recording/distance_recorder.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";

// at this point i really don't care about code quality. i just need this to work
class CacheAndDistance {
  final Cache cache;
  final double distance;
  final bool isStarred;

  CacheAndDistance({
    required this.cache,
    required Position position,
    required this.isStarred,
  }) : distance = haversineGeoPoint(cache.position, position.toGeoPoint());
}

class CacheListPage extends StatelessWidget {
  const CacheListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // sorry.
    return CanaFutureBuilder(
      future: verifyLocationPermissions().then(
        (_) => Geolocator.getCurrentPosition(),
      ),
      // position
      builder: (context, initialPosition) => CanaStreamBuilder(
        initialData: initialPosition,
        stream: Geolocator.getPositionStream(),
        // all caches
        builder: (context, position) => CanaStreamBuilder(
          stream: Caches().streamObjects(),
          // current user
          builder: (context, caches) => CanaStreamBuilder(
            stream: Users().streamCurrentUser(),
            // the ACTUAL LIST OF CACHES FINALLY
            builder: (context, user) => CacheList(
              items: caches
                  .map(
                    (cache) => CacheAndDistance(
                      cache: cache,
                      position: position,
                      isStarred: user.starredCacheIds.contains(cache.ref.id),
                    ),
                  )
                  .toList(),
              user: user,
            ),
          ),
        ),
      ),
    );
  }
}
