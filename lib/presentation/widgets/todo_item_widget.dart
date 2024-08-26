// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:to_do/domain/entities/todo.dart';
// import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

// class TodoItemWidget extends StatelessWidget {
//   final Todo todo;
//   final Function(String, String)? onAdd;
//   final Function(Todo) onUpdate;

//   const TodoItemWidget(
//       {super.key,
//       required this.todo,
//       required this.onUpdate,
//       required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         todo.title,
//         style: TextStyle(
//           decoration: todo.completed ? TextDecoration.lineThrough : null,
//         ),
//       ),
//       subtitle: Text(todo.description),
//       leading: Checkbox(
//         value: todo.completed,
//         onChanged: (bool? value) {
//           if (value != null) {
//             final updatedTodo = Todo(
//               id: todo.id,
//               title: todo.title,
//               description: todo.description,
//               completed: value,
//             );
//             onUpdate(updatedTodo);
//           }
//         },
//         // onChanged: (bool? value) {
//         //   context.read<TodoBloc>().add(
//         //         UpdateTodoEvent(
//         //           Todo(
//         //             id: todo.id,
//         //             title: todo.title,
//         //             description: todo.description,
//         //             completed: value ?? false,
//         //           ),
//         //         ),
//         //       );
//         // },
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.blue),
//             onPressed: () => _showEditTodoDialog(context),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete, color: Colors.red),
//             onPressed: () {
//               context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
//             },
//           ),
//         ],
//       ),
//     );
//   }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(String, String)? onAdd;
  final Function(Todo) onUpdate;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onUpdate,
    required this.onAdd,
  });

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: GestureDetector(
          onTap: () {
            final updatedTodo = Todo(
              id: todo.id,
              title: todo.title,
              description: todo.description,
              completed: !todo.completed,
            );
            onUpdate(updatedTodo);
          },
          child: Icon(
            todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: todo.completed ? Colors.green : Colors.grey,
            size: 28,
          ),
        ),
        title: Text(
          capitalizeFirstLetter(todo.title),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            capitalizeFirstLetter(todo.description),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
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
      ),
    );
  }

  void _showEditTodoDialog(BuildContext context) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

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
              decoration:
                  const InputDecoration(hintText: 'Update todo description'),
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

              if (newTitle.isNotEmpty &&
                  (newTitle != todo.title ||
                      newDescription != todo.description)) {
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
