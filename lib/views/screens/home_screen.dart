import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          "TODO",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 28,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dashboard Cards
          StreamBuilder(
            stream: getdata.fetchTodo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                );
              }

              // 🟢 Handle no data
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final docs = snapshot.data!.docs;

              // 🟢 Handle empty collection
              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No tasks yet",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final totalCount = snapshot.data?.docs.length;

              final activeCount = snapshot.data?.docs
                  .where((doc) => doc['isCompleted'] == false)
                  .length;
              final doneCount = snapshot.data?.docs
                  .where((doc) => doc['isCompleted'] == true)
                  .length;
              String done = doneCount.toString();
              final progressCount = totalCount == 0
                  ? 0
                  : (doneCount! / (totalCount)! * 100);
              final progress = "${progressCount.toString()}%";
              return Container(
                height: 140,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // TOTAL Card
                    Container(
                      width: 160,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: Colors.black,
                                size: 24,
                              ),
                              Text(
                                "$totalCount",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "TOTAL",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // ACTIVE Card
                    Container(
                      width: 160,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.pending_actions,
                                color: Colors.white,
                                size: 24,
                              ),
                              Text(
                                "$activeCount",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "ACTIVE",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // DONE Card
                    Container(
                      width: 160,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                              Text(
                                done,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "DONE",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // PROGRESS Card
                    Container(
                      width: 160,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.white,
                                size: 24,
                              ),
                              Text(
                                progress,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "PROGRESS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // StreamBuilder
          Expanded(
            child: StreamBuilder(
              stream: getdata.fetchTodo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1,
                    ),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                      "An error occurred",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                final data = snapshot.data!;

                if (data.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.grey[800],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No tasks yet",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: data.docs.length,
                  itemBuilder: (context, index) {
                    final todo = data.docs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: Colors.grey[900]!, width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    getdata.toggleCheckbox(
                                      todoId: todo.id,
                                      isCompleted: !todo["isCompleted"],
                                    );
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: todo["isCompleted"]
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: todo["isCompleted"]
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        todo['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.black,
                                          decoration: todo["isCompleted"]
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        todo['description'],
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.black, width: 2),
        ),
        child: Icon(Icons.add, color: Colors.black, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _AddTaskSheet extends StatelessWidget {
  const _AddTaskSheet();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
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
          userid: userId!,
        );

        final todoProvider = Provider.of<TodoProvider>(context, listen: false);
        todoProvider.saveTodo(todo);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                "Task added successfully",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.8,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(color: Colors.black),
                    ),
                  ),
                  const Text(
                    "NEW TASK",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 24,
                      color: Colors.black,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
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
                      labelText: "Title",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red[300]!),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        "ADD TASK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
