import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do/core/constants/api_constants.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos(String token);
  Future<TodoModel> addTodo(String title, String description, String token);
  Future<TodoModel> updateTodo(TodoModel todo, String token);
  Future<void> deleteTodo(String id, String token);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;

  TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TodoModel>> getTodos(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final Map<String, dynamic> data = responseBody['data'];
        final String username = data['username'];
        final List<dynamic> tasksJson = data['tasks'];
        return tasksJson
            .map((json) => TodoModel.fromJson({...json, 'username': username}))
            .toList();
      } else {
        throw ServerFailure(
            json.decode(response.body)['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<TodoModel> addTodo(
      String title, String description, String token) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}'),
        body: jsonEncode({'title': title, 'description': description}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['data'] != null) {
          return TodoModel.fromJson(responseBody['data']);
        } else {
          throw const ServerFailure('Invalid response format');
        }
      } else {
        throw ServerFailure(
            json.decode(response.body)['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo, String token) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}/${todo.id}'),
        body: jsonEncode(todo.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['data'] != null) {
          return TodoModel.fromJson(responseBody['data']);
        } else {
          throw const ServerFailure('Invalid response format');
        }
      } else {
        throw ServerFailure(
            json.decode(response.body)['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteTodo(String id, String token) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.todos}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw ServerFailure(
            json.decode(response.body)['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
