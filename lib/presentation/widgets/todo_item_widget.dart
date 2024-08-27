// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:to_do/domain/entities/todo.dart';
// import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

// class TodoItemWidget extends StatelessWidget {
//   final Todo todo;
//   final Function(String, String)? onAdd;
//   final Function(Todo) onUpdate;

//   const TodoItemWidget({
//     super.key,
//     required this.todo,
//     required this.onUpdate,
//     required this.onAdd,
//   });

//   String capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 5,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: GestureDetector(
//           onTap: () {
//             final updatedTodo = Todo(
//               id: todo.id,
//               title: todo.title,
//               description: todo.description,
//               completed: !todo.completed,
//             );
//             onUpdate(updatedTodo);
//           },
//           child: Icon(
//             todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
//             color: todo.completed ? Colors.green : Colors.grey,
//             size: 28,
//           ),
//         ),
//         title: Text(
//           capitalizeFirstLetter(todo.title),
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             decoration: todo.completed ? TextDecoration.lineThrough : null,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(
//             capitalizeFirstLetter(todo.description),
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.blue),
//               onPressed: () => _showEditTodoDialog(context),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditTodoDialog(BuildContext context) {
//     final titleController = TextEditingController(text: todo.title);
//     final descriptionController = TextEditingController(text: todo.description);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState)
//           {
//             void updateButtonState() {
//               setState(() {});
//             }

//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               title: const Text(
//                 'Edit Todo',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: InputDecoration(
//                       hintText: 'Update todo title',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     autofocus: true,
//                     onChanged: (value) {
//                       updateButtonState(); // Update state on title change
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: descriptionController,
//                     decoration: InputDecoration(
//                       hintText: 'Update todo description',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     maxLines: 3,
//                     onChanged: (value) {
//                       updateButtonState(); // Update state on description change
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: titleController.text.isNotEmpty &&
//                           (titleController.text != todo.title ||
//                               descriptionController.text != todo.description)
//                       ? () {
//                           final newTitle = titleController.text;
//                           final newDescription = descriptionController.text;

//                           if (newTitle.isNotEmpty) {
//                             context.read<TodoBloc>().add(
//                                   UpdateTodoEvent(
//                                     Todo(
//                                       id: todo.id,
//                                       title: newTitle,
//                                       description: newDescription,
//                                       completed: todo.completed,
//                                     ),
//                                   ),
//                                 );
//                             Navigator.pop(context);
//                           }
//                         }
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     disabledBackgroundColor: Colors.grey.shade300,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 10,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(String, String)? onAdd;
  final Function(Todo) onUpdate;

  const TodoItemWidget({
    Key? key,
    required this.todo,
    required this.onUpdate,
    required this.onAdd,
  }) : super(key: key);

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: _buildSwipeActionBackground(
        color: Colors.green,
        icon: Icons.check,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeActionBackground(
        color: Colors.red,
        icon: Icons.delete,
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
        } else {
          final updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            completed: true,
          );
          onUpdate(updatedTodo);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: todo.completed
                  ? [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.3)
                    ]
                  : [
                      Colors.blue.withOpacity(0.1),
                      Colors.blue.withOpacity(0.3)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: GestureDetector(
              onTap: () => _toggleTodoCompletion(context),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  todo.completed
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  key: ValueKey<bool>(todo.completed),
                  color: todo.completed ? Colors.green : Colors.grey,
                  size: 28,
                ),
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
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditTodoDialog(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeActionBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }

  void _toggleTodoCompletion(BuildContext context) {
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: !todo.completed,
    );
    onUpdate(updatedTodo);
  }

  void _showEditTodoDialog(BuildContext context) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateButtonState() {
              setState(() {});
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Edit Todo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Update todo title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      updateButtonState();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Update todo description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      updateButtonState();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: titleController.text.isNotEmpty &&
                          (titleController.text != todo.title ||
                              descriptionController.text != todo.description)
                      ? () {
                          final newTitle = titleController.text;
                          final newDescription = descriptionController.text;

                          if (newTitle.isNotEmpty) {
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
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
