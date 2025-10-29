import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/%20models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> todoList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String todoCollection = "todos";

  Future<DocumentReference?> saveTodo(Todo todo) async {
    try {
      final savingTodo = await _firestore.collection(todoCollection).add({
        "title": todo.title,
        "description": todo.description,
        "created_at": FieldValue.serverTimestamp(),
        "isCompleted": todo.isCompleted,
        "userId": todo.userid,
      });

      return savingTodo;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot>? fetchTodo() {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // If user is not logged in, return null or empty stream
      if (user == null) {
        print("No user logged in");
        return const Stream.empty();
      }

      // Only fetch todos where userId == current user's uid
      final fetchData = _firestore
          .collection("todos")
          .where("userId",)
          .orderBy("created_at", descending: true)
          .snapshots();

      return fetchData;
    } catch (e) {
      print("Error fetching user-specific todos: $e");
      return Stream.empty();
    }
  }
  /*
  Stream<QuerySnapshot>? fetchTodo() {
    try {
      final fetchData = _firestore.collection("todos").snapshots();
      return fetchData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  */

  Future<void> toggleCheckbox({
    required String todoId,
    required bool isCompleted,
  }) async {
    final awaiting = await _firestore
        .collection(todoCollection)
        .doc(todoId)
        .update({"isCompleted": isCompleted});
  }
}
