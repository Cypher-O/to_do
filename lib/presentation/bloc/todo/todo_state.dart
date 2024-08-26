part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  final String username;
  
  const TodoState({this.username = ''});
  
  @override
  List<Object> get props => [username];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded({required this.todos, required super.username});

  @override
  List<Object> get props => [todos, username];
}

class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message, super.username});

  @override
  List<Object> get props => [message, username];
}


// abstract class TodoState extends Equatable {
//   const TodoState();
  
//   @override
//   List<Object> get props => [];
// }

// class TodoInitial extends TodoState {}

// class TodoLoading extends TodoState {}

// class TodoLoaded extends TodoState {
//   final List<Todo> todos;

//   const TodoLoaded(this.todos);

//   @override
//   List<Object> get props => [todos];
// }

// class TodoError extends TodoState {
//   final String message;

//   const TodoError(this.message);

//   @override
//   List<Object> get props => [message];
// }