// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:to_do/domain/entities/todo.dart';
// import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';
// import 'package:to_do/presentation/widgets/animated_fab.dart';
// import 'package:to_do/presentation/widgets/todo_item_widget.dart';

// class TodoListPage extends StatefulWidget {
//   const TodoListPage({super.key});

//   @override
//   State<TodoListPage> createState() => _TodoListPageState();
// }

// class _TodoListPageState extends State<TodoListPage> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   late List<Todo> _sortedTodos;

//   @override
//   void initState() {
//     super.initState();
//     _sortedTodos = [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TodoBloc, TodoState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             // title: state is TodoLoaded && state.todos.isNotEmpty
//             //     ? Text('Hi, ${state.todos.first.username}')
//             //     : const Text('Todo List'),
//             title: Text(state.username.isNotEmpty
//                 ? 'Hi, ${state.username}'
//                 : 'Todo List'),
//             // centerTitle: true,
//           ),
//           body: BlocConsumer<TodoBloc, TodoState>(
//             listener: (context, state) {
//               if (state is TodoLoaded) {
//                 _updateSortedTodos(state.todos);
//               }
//             },
//             builder: (context, state) {
//               if (state is TodoLoaded) {
//                 if (state.todos.isEmpty) {
//                   return const Center(
//                       child: Text('No todos available. Add some!'));
//                 }
//                 return AnimatedList(
//                   key: _listKey,
//                   initialItemCount: _sortedTodos.length,
//                   itemBuilder: (context, index, animation) {
//                     return _buildItem(_sortedTodos[index], animation, index);
//                   },
//                 );
//               } else if (state is TodoError) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.message)),
//                   );
//                 });
//                 return const Center(
//                     child: Text('An error occurred. Please try again.'));
//               }
//               return const Center(child: CircularProgressIndicator());
//             },
//           ),
//           floatingActionButton: AnimatedFAB(
//             onPressedCallback: () => _showAddTodoDialog(context),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildItem(Todo todo, Animation<double> animation, int index) {
//     return SizeTransition(
//       sizeFactor: animation,
//       child: TodoItemWidget(
//         key: ValueKey(todo.id),
//         todo: todo,
//         onAdd: (title, description) {
//           context.read<TodoBloc>().add(AddTodoEvent(title, description));
//         },
//         onUpdate: (updatedTodo) {
//           context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
//           _handleTodoUpdate(updatedTodo, index);
//         },
//       ),
//     );
//   }

//   void _updateSortedTodos(List<Todo> todos) {
//     final newSortedTodos = List<Todo>.from(todos)
//       ..sort((a, b) {
//         if (a.completed == b.completed) {
//           if (a.completed) {
//             // For completed items, sort by completion time (newest first)
//             return b.id.compareTo(a.id);
//           } else {
//             // For uncompleted items, sort by creation time (newest first)
//             return b.id.compareTo(a.id);
//           }
//         }
//         return a.completed ? 1 : -1;
//       });

//     if (_sortedTodos.isEmpty) {
//       setState(() {
//         _sortedTodos = newSortedTodos;
//       });
//     } else {
//       for (int i = 0; i < newSortedTodos.length; i++) {
//         final newTodo = newSortedTodos[i];
//         final oldIndex = _sortedTodos.indexWhere((t) => t.id == newTodo.id);
//         if (oldIndex == -1) {
//           // New todo added
//           _sortedTodos.insert(i, newTodo);
//           _listKey.currentState?.insertItem(i);
//         } else if (oldIndex != i) {
//           // Todo position changed
//           final todo = _sortedTodos.removeAt(oldIndex);
//           _listKey.currentState?.removeItem(
//             oldIndex,
//             (context, animation) => _buildItem(todo, animation, oldIndex),
//           );
//           _sortedTodos.insert(i, newTodo);
//           _listKey.currentState?.insertItem(i);
//         } else {
//           // Update the todo in place
//           _sortedTodos[i] = newTodo;
//         }
//       }
//       // Remove any todos that no longer exist
//       for (int i = _sortedTodos.length - 1; i >= 0; i--) {
//         if (!newSortedTodos.contains(_sortedTodos[i])) {
//           final todo = _sortedTodos.removeAt(i);
//           _listKey.currentState?.removeItem(
//             i,
//             (context, animation) => _buildItem(todo, animation, i),
//           );
//         }
//       }
//     }
//   }

//   void _handleTodoUpdate(Todo updatedTodo, int oldIndex) {
//     int newIndex;
//     if (updatedTodo.completed) {
//       // Find the index of the first completed item
//       newIndex = _sortedTodos.indexWhere((todo) => todo.completed);
//       if (newIndex == -1) {
//         // If no completed items, append to the end
//         newIndex = _sortedTodos.length;
//       }
//     } else {
//       // For uncompleted items, move to the top
//       newIndex = 0;
//     }

//     if (oldIndex != newIndex) {
//       final item = _sortedTodos.removeAt(oldIndex);
//       _listKey.currentState?.removeItem(
//         oldIndex,
//         (context, animation) => _buildItem(item, animation, oldIndex),
//         duration: const Duration(milliseconds: 300),
//       );
//       _sortedTodos.insert(newIndex, updatedTodo);
//       _listKey.currentState
//           ?.insertItem(newIndex, duration: const Duration(milliseconds: 300));
//     } else {
//       _sortedTodos[newIndex] = updatedTodo;
//     }
//   }

// void _showAddTodoDialog(BuildContext context) {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           // Function to check if both fields are non-empty
//           bool isButtonEnabled() {
//             return titleController.text.isNotEmpty &&
//                    descriptionController.text.isNotEmpty;
//           }

//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Text(
//               'Add Todo',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(
//                     hintText: 'Enter todo title',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   autofocus: true,
//                   onChanged: (value) {
//                     setState(() {}); // Update button state on title change
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(
//                     hintText: 'Enter todo description',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   maxLines: 3,
//                   onChanged: (value) {
//                     setState(() {}); // Update button state on description change
//                   },
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: isButtonEnabled()
//                     ? () {
//                         final title = titleController.text;
//                         final description = descriptionController.text;

//                         context.read<TodoBloc>().add(
//                               AddTodoEvent(title, description),
//                             );
//                         Navigator.pop(context);
//                       }
//                     : null, // Disable button if either field is empty
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   disabledBackgroundColor: Colors.grey.shade300,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Add',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';
import 'package:to_do/presentation/widgets/animated_fab.dart';
import 'package:to_do/presentation/widgets/todo_item_widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

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
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: BlocConsumer<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoLoaded) {
                _updateSortedTodos(state.todos);
                _fadeController.forward();
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
      ),
    );
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
