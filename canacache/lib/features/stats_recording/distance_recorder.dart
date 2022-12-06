import "dart:async";
import "dart:math";
import "package:canacache/common/utils/db_ops.dart";
import "package:canacache/common/utils/db_schema.dart";
import "package:geolocator/geolocator.dart";
import "package:vector_math/vector_math.dart";

class LocationPermException implements Exception {
  String cause;
  LocationPermException(this.cause);
}

class DistanceRecorder {
  Position? lastPos;
  static const interval = 5;

  // this is ripped directly from https://pub.dev/packages/geolocator
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationPermException("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermException("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermException(
        "Location permissions are permanently denied, we cannot request permissions.",
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  // "borrowed" from here https://stackoverflow.com/questions/15736995/how-can-i-quickly-estimate-the-distance-between-two-latitude-longitude-points
  double haversine(Position pos1, Position pos2) {
    double lat1 = radians(pos1.latitude);
    double lat2 = radians(pos2.latitude);

    double lon1 = radians(pos1.longitude);
    double lon2 = radians(pos2.longitude);

    double dLon = lon2 - lon1;
    double dLat = lat2 - lat1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);

    double c = 2 * asin(sqrt(a));

    // accepted value for radius of earth in meters
    // https://en.wikipedia.org/wiki/Earth_radius#History
    double m = 6378100.0 * c;
    return m;
  }

  Future<void> newEpoch() async {
    Position currentPos;
    try {
      currentPos = await _determinePosition();
    } on LocationPermException catch (_) {
      return;
    }

    if (lastPos != null) {
      DateTime now = DateTime.now();
      DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
      int distance = haversine(currentPos, lastPos!).floor();

      // more than a few meters of noise in most gps
      // 4 meters should be more than enought to ignore most noise
      if (distance > 4) {
        var db = await init();

        List<Object> args = [currentHour.toString(), distance, distance];

        String dbString =
            """INSERT INTO ${DBTable.distance.tableTitle} (timeSlice, distance)
              VALUES(?,?)
              ON CONFLICT(timeSlice)
              DO UPDATE SET distance = distance+?;""";

        await db.execute(dbString, args);
      }
    }
    lastPos = currentPos;
  }
}
