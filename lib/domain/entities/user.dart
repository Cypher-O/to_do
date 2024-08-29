import 'package:to_do/core/utils/imports/plugin_import.dart';

class User extends Equatable {
  final String? id;
  final String? email;
  final String token;

  const User({this.id, this.email, required this.token});

  @override
  List<Object?> get props => [id, email, token];
}