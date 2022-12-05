enum DistanceUnit {
  kilometer,
  meter,
  mile,
  yard;

  @override
  String toString() => name;

  static DistanceUnit defaultUnit = DistanceUnit.kilometer;
}

class Unit {
  // Class only exists for future use, may want to add other units (time format, temp, etc)
  DistanceUnit distanceUnit;

  Unit({DistanceUnit? distanceUnit})
      : distanceUnit = distanceUnit ?? DistanceUnit.defaultUnit;
}
