import "package:cloud_firestore/cloud_firestore.dart";

extension GeoPointToString on GeoPoint {
  String toLatLng() {
    return "${latitude.abs().toStringAsFixed(4)} ${latitude >= 0 ? "N" : "S"}"
        " / ${longitude.abs().toStringAsFixed(4)} ${longitude >= 0 ? "E" : "W"}";
  }
}
