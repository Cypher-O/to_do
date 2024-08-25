import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';
import 'package:to_do/presentation/widgets/todo_item_widget.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No todos available. Add some!'));
            }
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return TodoItemWidget(todo: todo,
                onAdd: (addedTodo) {
                  context.read<TodoBloc>().add(UpdateTodoEvent(addedTodo));
                },
                onUpdate: (updatedTodo) {
              context.read<TodoBloc>().add(UpdateTodoEvent(updatedTodo));
            },);
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
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