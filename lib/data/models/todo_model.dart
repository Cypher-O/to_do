import 'package:to_do/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.completed,
    required super.username,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      username: json['username'] ?? ''
    );
  }

  factory TodoModel.fromTodo(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      username: todo.username, 
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'username': username,
    };
  }
}