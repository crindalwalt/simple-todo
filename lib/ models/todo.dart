import 'package:firebase_auth/firebase_auth.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime created_at;
  final bool isCompleted;
  final String userid;

  Todo({
    required this.title,
    required this.description,
    required this.id,
    required this.created_at,
    required this.isCompleted,
    required this.userid,
  });
}
