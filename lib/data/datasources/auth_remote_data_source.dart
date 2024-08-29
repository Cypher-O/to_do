import 'package:http/http.dart' as http;
import 'package:to_do/core/constants/api_constants.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/core/utils/imports/dart_import.dart';
import 'package:to_do/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String username, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerFailure(jsonResponse['message'] ?? 'Unknown error occurred');
        }
      } else {
        throw ServerFailure('Server error with status code ${response.statusCode}');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> register(String username, String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerFailure(jsonResponse['message'] ?? 'Unknown error occurred');
        }
      } else {
        throw ServerFailure('Server error with status code ${response.statusCode}');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}