import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Future<List<Todo>> _todoList;

  @override
  void initState() {
    super.initState();
    _todoList = ApiService().fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      body: FutureBuilder<List<Todo>>(
        future: _todoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }

          return ListView(
            children: snapshot.data!.map((todo) {
              return ListTile(
                title: Text(todo.title),
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: null,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
