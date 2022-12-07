enum DistanceUnit {
  kilometer("km"),
  meter("m"),
  mile("mi"),
  yard("y");

  final String abbreviation;

  const DistanceUnit(this.abbreviation);

  @override
  String toString() => name;

  /// i18n translation key
  String get nameKey => "settings.units.distance.options.$name";

  static DistanceUnit defaultUnit = DistanceUnit.kilometer;
}

class Unit {
  // Class only exists for future use, may want to add other units (time format, temp, etc)
  DistanceUnit distanceUnit;

  Unit({DistanceUnit? distanceUnit})
      : distanceUnit = distanceUnit ?? DistanceUnit.defaultUnit;
}
