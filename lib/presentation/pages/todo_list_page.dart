import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';
import 'package:to_do/presentation/widgets/todo_item_widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
   late List<Todo> _sortedTodos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoLoaded) {
            _updateSortedTodos(state.todos);
          }
        },
        builder: (context, state) {
          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No todos available. Add some!'));
            }
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return TodoItemWidget(
                  key: ValueKey(todo.id), 
                  todo: todo,
                  onAdd: (title, description) {
                  context.read<TodoBloc>().add(AddTodoEvent(title, description));
                },
                  onUpdate: (updatedTodo) {
                    context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
                  },
                );
              },
            );
          } else if (state is TodoError) {
            // Show a snackbar with the error message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            });
            // Return the last known good state or an empty list
            return const Center(child: Text('An error occurred. Please try again.'));
          }
          // Initial loading state
          return const Center(child: CircularProgressIndicator());
        //   if (state is TodoLoading) {
        //     return const Center(child: CircularProgressIndicator());
        //   } else if (state is TodoLoaded) {
        //     if (state.todos.isEmpty) {
        //       return const Center(child: Text('No todos available. Add some!'));
        //     }
        //     return ListView.builder(
        //       itemCount: state.todos.length,
        //       itemBuilder: (context, index) {
        //         final todo = state.todos[index];
        //         return TodoItemWidget(todo: todo,
        //         onAdd: (addedTodo) {
        //           context.read<TodoBloc>().add(UpdateTodoEvent(addedTodo));
        //         },
        //         onUpdate: (updatedTodo) {
        //       context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
        //     },);
        //       },
        //     );
        //   } else if (state is TodoError) {
        //     return Center(child: Text(state.message));
        //   }
        //   return const Center(child: Text('Something went wrong.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

   Widget _buildItem(Todo todo, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: TodoItemWidget(
        key: ValueKey(todo.id),
        todo: todo,
        onAdd: (title, description) {
          context.read<TodoBloc>().add(AddTodoEvent(title, description));
        },
        onUpdate: (updatedTodo) {
          context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
          _handleTodoUpdate(updatedTodo, index);
        },
      ),
    );
  }

  void _updateSortedTodos(List<Todo> todos) {
    setState(() {
      _sortedTodos = List.from(todos)
        ..sort((a, b) {
          if (a.completed == b.completed) {
            return b.id.compareTo(a.id); // Newest uncompleted at the top
          }
          return a.completed ? 1 : -1;
        });
    });
  }

  void _handleTodoUpdate(Todo updatedTodo, int oldIndex) {
    final newIndex = _sortedTodos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (oldIndex != newIndex) {
      final item = _sortedTodos.removeAt(oldIndex);
      _listKey.currentState?.removeItem(
        oldIndex,
        (context, animation) => _buildItem(item, animation, oldIndex),
        duration: const Duration(milliseconds: 300),
      );
      _sortedTodos.insert(newIndex, updatedTodo);
      _listKey.currentState?.insertItem(newIndex, duration: const Duration(milliseconds: 300));
    }
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter todo title'),
              autofocus: true,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Enter todo description'),
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
              final title = titleController.text;
              final description = descriptionController.text;

              if (title.isNotEmpty) {
                context.read<TodoBloc>().add(AddTodoEvent(title, description));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}