class Unit {
  String _unit = defaultUnit;
  static String defaultUnit = "Km";

  String get unit => _unit;

  set unit(String key) {
    if (!isValidUnit(key)) {
      throw Exception("Invalid Unit Passed");
    }

    _unit = key;
  }

  Unit({required unit}) {
    if (isValidUnit(unit)) {
      unit = unit;
    } else {
      unit = defaultUnit;
    }
  }

  static Unit initUnit(String unit) {
    return Unit(unit: unit);
  }

  static const Map<String, void> validUnits = {"Km": null, "Miles": null};

  static bool isValidUnit(String key) {
    return validUnits.containsKey(key);
  }

  @override
  String toString() {
    return unit;
  }
}
