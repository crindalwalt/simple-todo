import 'package:flutter/material.dart';
import 'package:simple_todo/%20models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> todoList = [];

  void saveTodo (Todo todo){
    print("data arived in the provider");
    print(todo.id);

    todoList.add(todo);

    print("todo list lenght is ");
    print(todoList.length);
  }
}