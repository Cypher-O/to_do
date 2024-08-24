import 'package:to_do/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({required int id, required String title, required bool completed})
      : super(id: id, title: title, completed: completed);

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}