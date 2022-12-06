library map;

import "dart:math";
import "package:canacache/features/firestore/model/collections/caches.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class HomePageMapModel {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );

// Do not touch these
  final String _token =
      "pk.eyJ1IjoibWFwNzMzMSIsImEiOiJjbGFnNmNkYWQxYXlhM29xeXJpY2I0dzVvIn0.YchBb4ONJyhaPMzXanClEQ";
  final String _mapID =
      "https://api.mapbox.com/styles/v1/map7331/clag6jg8a000215rvo3v6xq14/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFwNzMzMSIsImEiOiJjbGFnNmNkYWQxYXlhM29xeXJpY2I0dzVvIn0.YchBb4ONJyhaPMzXanClEQ";

  double currentZoomLevel = 25;
  final manhattanDistance = 20; // units are km
  bool firstLocation = true;

  final MapController mapController = MapController();
  List<Cache> caches = [];

  MapOptions options = MapOptions(
    minZoom: 3,
    maxZoom: 30,
    zoom: 25,
    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
  );

  TileLayerOptions? auth;
  LatLng currentPos = LatLng(0, 0);

  // some of the lat/long math/logic is taken from here https://stackoverflow.com/questions/1253499/simple-calculations-for-working-with-lat-lon-and-km-distance
  // same as here https://stackoverflow.com/questions/46630507/how-to-run-a-geo-nearby-query-with-firestore
  // https://stackoverflow.com/questions/46630507/how-to-run-a-geo-nearby-query-with-firestore

  double latDegreeToKM() {
    return 1 / 110.574;
  }

  double longDegreeToKM(LatLng pos) {
    return 1 / (111.320 * cos(pos.latitudeInRad));
  }

  Future<List<Cache>> getNearbyCaches() async {
    double latCorrection = (latDegreeToKM() * manhattanDistance);
    double longCorrection = (longDegreeToKM(currentPos) * manhattanDistance);

    GeoPoint lower = GeoPoint(
      currentPos.latitude - latCorrection,
      currentPos.longitude - longCorrection,
    );

    GeoPoint higher = GeoPoint(
      currentPos.latitude + latCorrection,
      currentPos.longitude + longCorrection,
    );
    List<Cache> newCaches = [];

    // this is not exactly radial
    // but a square box should be sufficient
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection("caches")
        .where("position", isGreaterThan: lower)
        .where("position", isLessThan: higher)
        .get();

    for (DocumentSnapshot<Map<String, dynamic>> doc in res.docs) {
      newCaches.add(Caches().fromFirestore(doc, null));
    }
    return newCaches;
  }

  HomePageMapModel() {
    auth = TileLayerOptions(
      urlTemplate: _mapID,
      additionalOptions: {
        "accessToken": _token,
      },
    );
  }

  //Position

}
