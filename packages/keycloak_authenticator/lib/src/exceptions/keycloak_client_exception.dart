import 'package:dio/dio.dart';

class KeycloakClientException implements Exception {
  String message;
  KeycloakExceptionType type;
  DioException dioException;
  KeycloakClientException(
    this.message, {
    required this.dioException,
    this.type = KeycloakExceptionType.badRequest,
  });
}

enum KeycloakExceptionType {
  networkError,
  unknown,
  notRegistered,
  serverError,
  badRequest,
}
