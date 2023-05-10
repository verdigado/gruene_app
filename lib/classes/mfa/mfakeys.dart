import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStoreKeysMFA {
  mfaPublicKey,
  mfaPrivateKey,
  mfaKeyPair,
}

class MFA {
  final FlutterSecureStorage _mfaStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<dynamic> _generateKeys() async {
    final algorithm = RsaSsaPkcs1v15(Sha512());

    // Generate a key pair
    final keyPair = await algorithm.newKeyPair();
    return keyPair;
  }

  void _saveKeypair(keyPair) async {
    Base64Codec base64 = const Base64Codec();
    await _mfaStorage.write(
        key: SecureStoreKeysMFA.mfaPrivateKey.toString(),
        value: base64.encode(keyPair.extract().codeUnits));

    await _mfaStorage.write(
        key: SecureStoreKeysMFA.mfaPublicKey.toString(),
        value: base64.encode(keyPair.extractPublicKey().codeUnits));
  }

  Future<bool> _keypairExists() async {
    return _mfaStorage
        .read(key: SecureStoreKeysMFA.mfaPrivateKey.toString())
        .then((value) => value != null ? true : false);
  }

  Future<String> getPublicKey() async {
    if (!await _keypairExists()) {
      final keyPair = await _generateKeys();
      _saveKeypair(keyPair);
    }

    final String publicKey = await _mfaStorage.read(
            key: SecureStoreKeysMFA.mfaPublicKey.toString()) ??
        '';
    return publicKey;
  }

  Future<String> getPrivateKey() async {
    if (!await _keypairExists()) {
      final keyPair = await _generateKeys();
      _saveKeypair(keyPair);
    }

    final String privateKey = await _mfaStorage.read(
            key: SecureStoreKeysMFA.mfaPrivateKey.toString()) ??
        '';
    return privateKey;
  }

  Future<Signature> sign(String secret) async {
    final algorithm = RsaSsaPkcs1v15(Sha512());

    if (!await _keypairExists()) {
      final keyPair = await _generateKeys();
      _saveKeypair(keyPair);
    }

    final signature = await algorithm.sign(secret.codeUnits,
        keyPair: await algorithm.newKeyPairFromSeed(
            await getPrivateKey().then((value) => value.codeUnits)));

    return signature;
  }
}
