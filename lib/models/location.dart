enum Location {

  hospital(
      "Hospital",
      "El hospital continúa atendiendo a los pacientes relacionados con el caso."
  ),

  police(
      "Comandancia",
      "La policía analiza las evidencias obtenidas durante la investigación."
  ),

  crimeScene(
      "Escena del crimen",
      "La zona permanece acordonada mientras se recolectan indicios."
  ),

  raveHouse(
      "Casa del rave",
      "El inmueble conserva restos de la fiesta y posibles evidencias."
  ),

  warehouse(
      "Warehouse",
      "El posible centro de distribución permanece bajo vigilancia."
  );

  const Location(
      this.label,
      this.description,
      );

  final String label;
  final String description;

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