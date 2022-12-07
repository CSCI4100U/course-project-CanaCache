import "package:canacache/features/stats_recording/distance_recorder.dart";
import "package:geolocator/geolocator.dart";

Future<bool> verifyLocationPermissions() async {
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

  return true;
}
