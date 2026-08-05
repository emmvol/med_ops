enum Location {
  hospital,
  police,
  crimeScene,
  raveHouse,
  warehouse,
}

extension LocationName on Location {
  String get label {
    switch (this) {
      case Location.hospital:
        return 'Hospital';
      case Location.police:
        return 'Comandancia';
      case Location.crimeScene:
        return 'Escena del crimen';
      case Location.raveHouse:
        return 'Casa del rave';
      case Location.warehouse:
        return 'Depósito';
    }
  }
}