class Category {
  final String id;
  final String name;
  final int position;
  final List<String> tasks;
  final DateTime created;
  final DateTime updated;

  Category({
    required this.id,
    required this.name,
    required this.position,
    required this.tasks,
    required this.created,
    required this.updated,
  });
}