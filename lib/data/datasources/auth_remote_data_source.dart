import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do/core/constants/api_constants.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulating login with JSONPlaceholder
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.users}?email=$email'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      if (users.isNotEmpty) {
        return UserModel.fromJson(users.first);
      } else {
        throw const ServerFailure('User not found');
      }
    } else {
      throw const ServerFailure('Failed to login');
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    // Simulating registration with JSONPlaceholder
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.users}'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw const ServerFailure('Failed to register');
    }
  }
}