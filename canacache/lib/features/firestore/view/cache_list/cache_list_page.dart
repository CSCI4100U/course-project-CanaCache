import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/common/utils/formatting_extensions.dart";
import "package:canacache/common/utils/geo.dart";
import "package:canacache/features/firestore/model/collections/caches.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/view/cache_list/cache_list.dart";
import "package:canacache/features/stats_recording/distance_recorder.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";

// at this point i really don't care about code quality. i just need this to work
class CacheAndDistance {
  final Cache cache;
  late final double distance;

  CacheAndDistance(this.cache, Position position) {
    distance = haversineGeoPoint(cache.position, position.toGeoPoint());
  }
}

class CacheListPage extends StatelessWidget {
  const CacheListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CanaFutureBuilder(
      future: verifyLocationPermissions().then(
        (_) => Geolocator.getCurrentPosition(),
      ),
      builder: (context, initialPosition) => CanaStreamBuilder<Position>(
        initialData: initialPosition,
        stream: Geolocator.getPositionStream(),
        builder: (context, position) => CanaStreamBuilder(
          stream: Caches().streamObjects(),
          builder: (context, caches) => CacheList(
            items: caches
                .map((cache) => CacheAndDistance(cache, position))
                .toList(),
          ),
        ),
      ),
    );
  }
}
