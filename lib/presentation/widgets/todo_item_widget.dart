import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;

  const TodoItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(todo.description ?? 'No description'),
      leading: Checkbox(
        value: todo.completed,
        onChanged: (bool? value) {
          context.read<TodoBloc>().add(
                UpdateTodoEvent(
                  Todo(
                    id: todo.id,
                    title: todo.title,
                    description: todo.description,
                    completed: value ?? false,
                  ),
                ),
              );
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditTodoDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
            },
          ),
        ],
      ),
    );
  }

  void _showEditTodoDialog(BuildContext context) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Update todo title'),
              autofocus: true,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Update todo description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newTitle = titleController.text;
              final newDescription = descriptionController.text;

              if (newTitle.isNotEmpty && (newTitle != todo.title || newDescription != todo.description)) {
                context.read<TodoBloc>().add(
                      UpdateTodoEvent(
                        Todo(
                          id: todo.id,
                          title: newTitle,
                          description: newDescription,
                          completed: todo.completed,
                        ),
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:to_do/domain/entities/todo.dart';
// import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

// class TodoItemWidget extends StatelessWidget {
//   final Todo todo;

//   const TodoItemWidget({super.key, required this.todo});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(todo.title),
//       leading: Checkbox(
//         value: todo.completed,
//         onChanged: (bool? value) {
//           context.read<TodoBloc>().add(
//                 UpdateTodoEvent(
//                   Todo(
//                     id: todo.id,
//                     title: todo.title,
//                     completed: value ?? false,
//                   ),
//                 ),
//               );
//         },
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.delete),
//         onPressed: () {
//           context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
//         },
//       ),
//     );
//   }
// }