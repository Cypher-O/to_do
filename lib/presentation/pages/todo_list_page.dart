import 'package:to_do/core/utils/imports/general_import.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/auth/auth_bloc.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

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
    // Dispatch LoadTodos event after confirming authentication
    context.read<AuthBloc>().add(CheckAuthentication());
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
              }
            },
            builder: (context, state) {
              if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoLoaded) {
                if (state.todos.isEmpty) {
                  return Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        noTodosAvailable,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
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
                return Center(
                  child: Text(
                    '$errorOccurred${state.message}',
                  ),
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

  void _handleTodoDismissal(
      Todo dismissedTodo, int index, DismissDirection direction) {
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
        // Keep newer items (higher ID or newly added items) at the top within their respective sections
        return b.id.compareTo(a.id);
      }
      return a.completed ? 1 : -1; // Place unchecked items at the top
    });
  }

  void _updateSortedTodos(List<Todo> todos) {
    final newSortedTodos = List<Todo>.from(todos)
      ..sort((a, b) {
        if (a.completed == b.completed) {
          return b.id
              .compareTo(a.id); // Sort newer items first within their section
        }
        return a.completed ? 1 : -1; // Unchecked items at the top
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
          // New todo, insert at the top of the respective section
          int newIndex = newTodo.completed
              ? _sortedTodos.indexWhere((todo) => todo.completed)
              : 0;

          if (newIndex == -1) newIndex = _sortedTodos.length;

          _sortedTodos.insert(newIndex, newTodo);
          _listKey.currentState?.insertItem(newIndex);
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
    // Remove the todo from its current position
    final item = _sortedTodos.removeAt(oldIndex);
    _listKey.currentState?.removeItem(
      oldIndex,
      (context, animation) => _buildItem(item, animation, oldIndex),
      duration: const Duration(milliseconds: 300),
    );

    // Determine the new index based on the completed state
    int newIndex = updatedTodo.completed
        ? _sortedTodos
            .indexWhere((todo) => todo.completed) // Top of checked section
        : _sortedTodos
            .indexWhere((todo) => todo.completed); // Top of unchecked section

    // If no matching section is found, append to the end
    if (newIndex == -1) {
      newIndex = updatedTodo.completed ? _sortedTodos.length : 0;
    }

    // Insert the updated todo at the new position
    _sortedTodos.insert(newIndex, updatedTodo);
    _listKey.currentState?.insertItem(
      newIndex,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TodoFormBottomSheet(
          title: addNewTodo,
          submitButtonText: addTodo,
          onSubmit: (title, description) {
            context.read<TodoBloc>().add(AddTodoEvent(title, description));
          },
        );
      },
    );
  }
}
