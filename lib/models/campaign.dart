class Campaign {
  final String id;

  final String title;

  /// Subtítulo corto
  final String subtitle;

  /// Descripción mostrada al seleccionar la campaña
  final String description;

  /// Introducción narrativa (se mostrará antes de iniciar)
  final List<String> intro;

  /// Objetivo principal
  final String objective;

  /// Orden de los capítulos o nodos principales
  final List<String> caseOrder;

  const Campaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.intro,
    required this.objective,
    required this.caseOrder,
  });
}