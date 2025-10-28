import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo/%20models/todo.dart';
import 'package:simple_todo/controllers/todo_provider.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final getdata = Provider.of<TodoProvider>(context);
    /*
    final tasks = [
      {'title': 'Buy groceries', 'subtitle': 'Milk, Eggs, Bread'},
      {'title': 'Finish project', 'subtitle': 'Due tomorrow'},
      {'title': 'Call Alice', 'subtitle': 'Discuss the meeting'},
      {'title': 'Read a book', 'subtitle': '30 minutes'},
    ];
    */

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Simple Todo",
          style: TextStyle(
            color: Color(0xFF222B45),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: getdata.fetchTodo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Text("an error occured");
          }

          final data = snapshot.data!;
          bool iscompleted = false;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final todo = data.docs[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Checkbox(value: todo["isCompleted"], onChanged: (value) {
                        
                    }),
                  ),
                  title: Text(
                    todo['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  subtitle: Text(
                    todo['description'],
                    style: const TextStyle(
                      color: Color(0xFF8F9BB3),
                      fontSize: 13,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF8F9BB3),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Task",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _AddTaskSheet extends StatelessWidget {
  const _AddTaskSheet();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _taskController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    void addTask() {
      if (_formKey.currentState!.validate()) {
        print("form is validated");
        final String title = _taskController.text;
        final String description = _descriptionController.text;
        print("========================================");
        print("========================================");
        print("========================================");
        print("Title => $title");
        print("Description => $description");
        print("========================================");
        print("========================================");
        print("========================================");

        final uuid = Uuid();
        final id = uuid.v4();
        print(id);

        final date = DateTime.now();

        final Todo todo = Todo(
          title: title,
          description: description,
          id: id,
          created_at: date,
          isCompleted: false,
        );

        final todoProvider = Provider.of<TodoProvider>(context, listen: false);
        todoProvider.saveTodo(todo);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: EdgeInsets.all(8),
              // margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Todo saved"),
            ),
            backgroundColor: Colors.transparent,
          ),
        );
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.35,
      maxChildSize: 0.8,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  "Add New Task",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF222B45),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _taskController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please fill the task";
                    }
                    if (value.length > 20) {
                      return "Maximum 20 words";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please fill the task";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Add Task",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
