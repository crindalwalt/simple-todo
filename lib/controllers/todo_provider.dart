import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/%20models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> todoList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String todoCollection = "todos";


  Future<DocumentReference?> saveTodo (Todo todo)async{

    try{
      final savingTodo = await _firestore.collection(todoCollection).add({
        "title" : todo.title,
        "description" : todo.description,
        "created_at" : FieldValue.serverTimestamp(),
        "isCompleted" : todo.isCompleted
      });

      return savingTodo;
    }catch(error){
      print(error.toString());
      return null;
    }
  }
}