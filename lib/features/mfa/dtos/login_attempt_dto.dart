import 'package:keycloak_authenticator/api.dart';

class LoginAttemptDto {
  final DateTime loggedInAt;
  final String ipAddress;
  final String browser;
  final String os;
  final Challenge challenge;
  final int expiresIn;
  final String clientName;

  LoginAttemptDto({
    required this.loggedInAt,
    required this.ipAddress,
    required this.browser,
    required this.os,
    required this.challenge,
    required this.expiresIn,
    required this.clientName,
  });
}
