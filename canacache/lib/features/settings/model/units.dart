enum DistanceUnit {
  kilometer,
  meter,
  mile,
  yard;

  @override
  String toString() {
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

  static DistanceUnit defaultUnit = DistanceUnit.kilometer;

  static DistanceUnit? fromString(String word) {
    for (DistanceUnit unit in DistanceUnit.values) {
      if (unit.name == word) {
        return unit;
      }
    }
    return null;
  }
}

class Unit {
  // Class only exists for future use, may want to add other units (time format, temp, etc)
  DistanceUnit distanceUnit = DistanceUnit.defaultUnit;

  Unit({required this.distanceUnit});
}
