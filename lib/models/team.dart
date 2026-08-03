class Team {
  final String name;

  int money;
  int trust;

  /// Nodo donde se encuentra actualmente este equipo
  String currentNode;

  /// Evidencias encontradas
  final List<String> evidence;

  /// Decisiones ya tomadas (evita repetir acciones)
  final Set<String> completedActions;

  Team({
    required this.name,
    this.money = 5000,
    this.trust = 100,
    this.currentNode = "START",
    List<String>? evidence,
    Set<String>? completedActions,
  })  : evidence = evidence ?? [],
        completedActions = completedActions ?? {};
}