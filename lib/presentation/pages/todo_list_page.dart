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
  void initState() {
    super.initState();
    _sortedTodos = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state is TodoLoaded && state.todos.isNotEmpty
                ? Text('Hi, ${state.todos.first.username}')
                : const Text('Todo List'),
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
                  return const Center(
                      child: Text('No todos available. Add some!'));
                }
                return AnimatedList(
                  key: _listKey,
                  initialItemCount: _sortedTodos.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(_sortedTodos[index], animation, index);
                  },
                );
              } else if (state is TodoError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                });
                return const Center(
                    child: Text('An error occurred. Please try again.'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTodoDialog(context),
            tooltip: 'Add Todo',
            child: const Icon(Icons.add),
          ),
        );
      },
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
    final newSortedTodos = List<Todo>.from(todos)
      ..sort((a, b) {
        if (a.completed == b.completed) {
          if (a.completed) {
            // For completed items, sort by completion time (newest first)
            return b.id.compareTo(a.id);
          } else {
            // For uncompleted items, sort by creation time (newest first)
            return b.id.compareTo(a.id);
          }
        }
        return a.completed ? 1 : -1;
      });

    if (_sortedTodos.isEmpty) {
      setState(() {
        _sortedTodos = newSortedTodos;
      });
    } else {
      for (int i = 0; i < newSortedTodos.length; i++) {
        final newTodo = newSortedTodos[i];
        final oldIndex = _sortedTodos.indexWhere((t) => t.id == newTodo.id);
        if (oldIndex == -1) {
          // New todo added
          _sortedTodos.insert(i, newTodo);
          _listKey.currentState?.insertItem(i);
        } else if (oldIndex != i) {
          // Todo position changed
          final todo = _sortedTodos.removeAt(oldIndex);
          _listKey.currentState?.removeItem(
            oldIndex,
            (context, animation) => _buildItem(todo, animation, oldIndex),
          );
          _sortedTodos.insert(i, newTodo);
          _listKey.currentState?.insertItem(i);
        } else {
          // Update the todo in place
          _sortedTodos[i] = newTodo;
        }
      }
      // Remove any todos that no longer exist
      for (int i = _sortedTodos.length - 1; i >= 0; i--) {
        if (!newSortedTodos.contains(_sortedTodos[i])) {
          final todo = _sortedTodos.removeAt(i);
          _listKey.currentState?.removeItem(
            i,
            (context, animation) => _buildItem(todo, animation, i),
          );
        }
      }
    }
  }

  void _handleTodoUpdate(Todo updatedTodo, int oldIndex) {
    int newIndex;
    if (updatedTodo.completed) {
      // Find the index of the first completed item
      newIndex = _sortedTodos.indexWhere((todo) => todo.completed);
      if (newIndex == -1) {
        // If no completed items, append to the end
        newIndex = _sortedTodos.length;
      }
    } else {
      // For uncompleted items, move to the top
      newIndex = 0;
    }

    if (oldIndex != newIndex) {
      final item = _sortedTodos.removeAt(oldIndex);
      _listKey.currentState?.removeItem(
        oldIndex,
        (context, animation) => _buildItem(item, animation, oldIndex),
        duration: const Duration(milliseconds: 300),
      );
      _sortedTodos.insert(newIndex, updatedTodo);
      _listKey.currentState
          ?.insertItem(newIndex, duration: const Duration(milliseconds: 300));
    } else {
      _sortedTodos[newIndex] = updatedTodo;
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
              decoration:
                  const InputDecoration(hintText: 'Enter todo description'),
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
