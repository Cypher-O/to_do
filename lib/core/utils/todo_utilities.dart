import 'package:to_do/domain/entities/todo.dart';

Todo toggleTodoCompletion(Todo todo) {
  return Todo(
    id: todo.id,
    title: todo.title,
    description: todo.description,
    completed: !todo.completed,
  );
}
