class Unit {
  String _unit = defaultUnit;
  static String defaultUnit = "Kilometre";
  static const Map<String, void> validUnits = {
    "Kilometre": null,
    "Metere": null,
    "Miles": null,
    "Yards": null,
  };

  String get unit => _unit;

  set unit(String key) {
    if (!isValidUnit(key)) {
      throw Exception("Invalid Unit Passed");
    }

    _unit = key;
  }

  Unit({required unit}) {
    if (isValidUnit(unit)) {
      _unit = unit;
    } else {
      _unit = defaultUnit;
    }
  }

  static Unit initUnit(String unit) {
    return Unit(unit: unit);
  }

  static bool isValidUnit(String key) {
    return validUnits.containsKey(key);
  }

  @override
  String toString() {
    return _unit;
  }

  @override
  bool operator ==(covariant Unit other) {
    return other.unit == _unit;
  }
}
