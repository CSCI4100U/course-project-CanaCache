import "package:cloud_firestore/cloud_firestore.dart";

extension GeoPointToString on GeoPoint {
  String toLatLng() {
    return "${latitude.abs().toStringAsFixed(4)} ${latitude >= 0 ? "N" : "S"}"
        " / ${longitude.abs().toStringAsFixed(4)} ${longitude >= 0 ? "E" : "W"}";
  }
}

extension EnumTryByName<T extends Enum> on Iterable<T> {
  /// Like [EnumByName.byName], but accepts null, and returns null if not found.
  T? tryByName(String? name) {
    if (name == null) return null;
    for (var value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}
