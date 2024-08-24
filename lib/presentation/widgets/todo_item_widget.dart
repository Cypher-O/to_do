import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;

  const TodoItemWidget({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      leading: Checkbox(
        value: todo.completed,
        onChanged: (bool? value) {
          context.read<TodoBloc>().add(
                UpdateTodoEvent(
                  Todo(
                    id: todo.id,
                    title: todo.title,
                    completed: value ?? false,
                  ),
                ),
              );
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
        },
      ),
    );
  }
}