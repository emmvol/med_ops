class Team {

  /// Nombre elegido por el equipo
  String name;

  /// Alfa, Bravo, Charlie...
  final String codeName;

  /// Hospital al que pertenecen
  String hospital;

  int money;
  int trust;

  /// Nodo actual de este equipo
  String currentNode;

  /// Evidencias descubiertas
  final List<String> evidence;

  int actionPoints;

  Team({

    required this.name,
    required this.codeName,
    required this.hospital,

    this.money = 5000,
    this.trust = 100,

    this.currentNode = "START",

    List<String>? evidence,

    this.actionPoints = 3,

  })  : evidence = evidence ?? [];

}