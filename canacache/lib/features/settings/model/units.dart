enum DistanceUnit {
  kilometer,
  meter,
  mile,
  yard;

  @override
  String toString() {
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

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
  static DistanceUnit defaultUnit = DistanceUnit.kilometer;
  DistanceUnit _distanceUnit = defaultUnit;

  DistanceUnit get distanceUnit => _distanceUnit;

  set distanceUnit(DistanceUnit unit) {
    _distanceUnit = unit;
  }

  Unit({required unit}) {
    _distanceUnit = unit;
  }

  static Unit initUnit(DistanceUnit unit) {
    return Unit(unit: unit);
  }
}
