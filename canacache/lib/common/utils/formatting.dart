import "package:canacache/features/settings/model/settings_provider.dart";
import "package:canacache/features/settings/model/units.dart";
import "package:intl/intl.dart";

String formatDistance(double distanceMeters, SettingsProvider settings) {
  final locale = settings.language.languageCode;
  final distanceUnit = settings.unit.distanceUnit;

  double distance;
  switch (distanceUnit) {
    case DistanceUnit.kilometer:
      distance = distanceMeters / 1000;
      break;
    case DistanceUnit.meter:
      distance = distanceMeters;
      break;
    case DistanceUnit.mile:
      distance = distanceMeters / 1609;
      break;
    case DistanceUnit.yard:
      // wtf, imperial
      distance = distanceMeters * 1.0936;
  }

  final formattedDistance = NumberFormat(null, locale).format(distance.round());
  return "$formattedDistance ${distanceUnit.abbreviation}";
}
