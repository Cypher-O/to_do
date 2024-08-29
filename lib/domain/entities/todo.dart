import 'package:to_do/core/utils/imports/plugin_import.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final String? username; 

  const Todo({required this.id, required this.title, required this.description, required this.completed, this.username});

  @override
  List<Object?> get props => [id, title, completed, username];
}
