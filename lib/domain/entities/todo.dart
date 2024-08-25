import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool completed;

  const Todo({required this.id, required this.title, required this.description, required this.completed});

  @override
  List<Object?> get props => [id, title, completed];
}
