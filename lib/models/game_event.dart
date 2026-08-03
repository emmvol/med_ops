class GameEvent {

  final String title;

  final String description;

  final bool affectsEveryone;

  const GameEvent({

    required this.title,

    required this.description,

    this.affectsEveryone = true,

  });

}