import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keycloak_authenticator/api.dart';

class MfaFactory {
  static AuthenticatorService create() {
    return AuthenticatorService(
      storage: FlutterSecureStorageAdapter(
        const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        ),
      ),
    );
  }
}
