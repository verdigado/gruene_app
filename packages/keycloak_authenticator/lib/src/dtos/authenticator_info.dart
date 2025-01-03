import 'package:keycloak_authenticator/src/enums/key_algorithm_enum.dart';
import 'package:keycloak_authenticator/src/enums/signature_algorithm_enum.dart';

class AuthenticatorInfo {
  final SignatureAlgorithm signatureAlgorithm;
  final KeyAlgorithm keyAlgorithm;
  final DateTime registeredAt;

  AuthenticatorInfo({
    required this.signatureAlgorithm,
    required this.keyAlgorithm,
    required this.registeredAt,
  });
}
