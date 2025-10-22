class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime created_at;
  final bool isCompleted;


  Todo({required this.title,required this.description, required this.id,required this.created_at , required this.isCompleted});
}