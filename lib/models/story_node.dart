import 'decision.dart';

class StoryNode {

  final String id;

  final String title;

  final String description;

  final List<Decision> decisions;

  const StoryNode({

    required this.id,

    required this.title,

    required this.description,

    required this.decisions,

  });

}