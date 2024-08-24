import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do/core/constants/api_constants.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo(String title);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(int id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;

  TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}'));

    if (response.statusCode == 200) {
      final List<dynamic> todoJson = json.decode(response.body);
      return todoJson.map((json) => TodoModel.fromJson(json)).toList();
    } else {
      throw const ServerFailure('Failed to fetch todos');
    }
  }

  @override
  Future<TodoModel> addTodo(String title) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}'),
      body: jsonEncode({'title': title, 'completed': false}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return TodoModel.fromJson(json.decode(response.body));
    } else {
      throw const ServerFailure('Failed to add todo');
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}/${todo.id}'),
      body: jsonEncode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return TodoModel.fromJson(json.decode(response.body));
    } else {
      throw const ServerFailure('Failed to update todo');
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}/$id'),
    );

    if (response.statusCode != 200) {
      throw const ServerFailure('Failed to delete todo');
    }
  }
}