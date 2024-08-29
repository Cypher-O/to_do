import 'package:to_do/core/utils/imports/general_import.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(String, String)? onAdd;
  final Function(Todo) onUpdate;
  final Function(Todo, DismissDirection) onDismissed;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onUpdate,
    required this.onAdd,
    required this.onDismissed,
  });

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _handleTodoDismissal(
      Todo todo, DismissDirection direction, BuildContext context) {
    if (direction == DismissDirection.endToStart) {
      // Delete the todo
      context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
    } else if (direction == DismissDirection.startToEnd) {
      // Toggle completion state of the todo
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        completed: !todo.completed,
      );
      context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: _buildSwipeActionBackground(
        color: todo.completed ? Colors.orange : Colors.green,
        icon: todo.completed ? Icons.refresh : Icons.check,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeActionBackground(
        color: Colors.red,
        icon: Icons.delete,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Confirm delete
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(confirm),
                content: Text(confirmationMessage),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(delete),
                  ),
                ],
              );
            },
          );
        } else if (direction == DismissDirection.startToEnd) {
          // Toggle completion state of the todo
          final updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            completed: !todo.completed,
          );
          context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));

          // Prevent the Dismissible from being dismissed visually
          return false; // Returning false to keep the Dismissible in the tree
        }
        return false;
      },
      onDismissed: (direction) {
        _handleTodoDismissal(todo, direction, context);
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateButtonState() {
              setState(() {});
            }

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      editTodo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: updateTodoTitle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.title),
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
                        hintText: updateTodoDescription,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        updateButtonState();
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: titleController.text.isNotEmpty &&
                              (titleController.text != todo.title ||
                                  descriptionController.text !=
                                      todo.description)
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        saveTodo,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
