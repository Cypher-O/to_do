import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';
import 'package:to_do/presentation/widgets/animated_fab.dart';
import 'package:to_do/presentation/widgets/todo_item_widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Todo> _sortedTodos;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _sortedTodos = [];
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.username.isNotEmpty ? 'Hi, ${state.username}' : 'Todo List',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          body: BlocConsumer<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoLoaded) {
                _updateSortedTodos(state.todos);
                _fadeController.forward();
                setState(() {}); 
              }
            },
            builder: (context, state) {
              if (state is TodoLoaded) {
                if (state.todos.isEmpty) {
                  return Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'No todos available. Add some!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  );
                }
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _sortedTodos.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_sortedTodos[index], animation, index);
                    },
                  ),
                );
              } else if (state is TodoError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                });
                return const Center(
                  child: Text('An error occurred. Please try again.'),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: AnimatedFAB(
            onPressedCallback: () => _showAddTodoDialog(context),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildItem(Todo todo, Animation<double> animation, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
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
        onDismissed: (dismissedTodo, direction) {
          _handleTodoDismissal(dismissedTodo, index, direction);
        },
      ),
    );
  }

  void _handleTodoDismissal(Todo dismissedTodo, int index, DismissDirection direction) {
    setState(() {
      _sortedTodos.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildItem(dismissedTodo, animation, index),
        duration: const Duration(milliseconds: 300),
      );
    });

    if (direction == DismissDirection.endToStart) {
      // Delete todo
      context.read<TodoBloc>().add(DeleteTodoEvent(dismissedTodo.id));
    } else {
      // Toggle completion
      final updatedTodo = Todo(
        id: dismissedTodo.id,
        title: dismissedTodo.title,
        description: dismissedTodo.description,
        completed: !dismissedTodo.completed,
      );
      context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
      
      // Re-add the updated todo to the list
      setState(() {
        _sortedTodos.add(updatedTodo);
        _sortTodos();
        _listKey.currentState?.insertItem(_sortedTodos.indexOf(updatedTodo));
      });
    }
  }

  void _sortTodos() {
    _sortedTodos.sort((a, b) {
      if (a.completed == b.completed) {
        return b.id.compareTo(a.id);
      }
      return a.completed ? 1 : -1;
    });
  }

  void _updateSortedTodos(List<Todo> todos) {
    final newSortedTodos = List<Todo>.from(todos)
      ..sort((a, b) {
        if (a.completed == b.completed) {
          return b.id.compareTo(a.id);
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
          _sortedTodos.insert(i, newTodo);
          _listKey.currentState?.insertItem(i);
        } else if (oldIndex != i) {
          final todo = _sortedTodos.removeAt(oldIndex);
          _listKey.currentState?.removeItem(
            oldIndex,
            (context, animation) => _buildItem(todo, animation, oldIndex),
          );
          _sortedTodos.insert(i, newTodo);
          _listKey.currentState?.insertItem(i);
        } else {
          _sortedTodos[i] = newTodo;
        }
      }
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
    int newIndex = updatedTodo.completed
        ? _sortedTodos.indexWhere((todo) => todo.completed)
        : 0;
    if (newIndex == -1) newIndex = _sortedTodos.length;

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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isButtonEnabled() {
              return titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty;
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
                    const Text(
                      'Add New Todo',
                      style: TextStyle(
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
                        hintText: 'Enter todo title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.title),
                      ),
                      autofocus: true,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter todo description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.description),
                      ),
                      maxLines: 3,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isButtonEnabled()
                          ? () {
                              context.read<TodoBloc>().add(
                                    AddTodoEvent(
                                      titleController.text,
                                      descriptionController.text,
                                    ),
                                  );
                              Navigator.pop(context);
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
                      child: const Text(
                        'Add Todo',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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