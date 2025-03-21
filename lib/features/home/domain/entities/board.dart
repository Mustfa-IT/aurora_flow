class Board {
  final String id;
  final String project;
  final List<String> categories;
  final DateTime created;
  final DateTime updated;

  Board({
    required this.id,
    required this.project,
    required this.categories,
    required this.created,
    required this.updated,
  });
}