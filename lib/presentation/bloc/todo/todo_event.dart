part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;

  const AddTodoEvent(this.title);

  @override
  List<Object> get props => [title];
}

class UpdateTodoEvent extends TodoEvent {
  final Todo updatedTodo;

  const UpdateTodoEvent(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}