import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SSKMFAData {
  mfadataRealmId,
  mfadataKey,
  mfadataClientId,
  mfadataTabId,
}

class MFAData {
  final FlutterSecureStorage _mfaDataStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  setRealmId(String realmId) async {
    await _mfaDataStorage.write(
        key: SSKMFAData.mfadataRealmId.toString(), value: realmId);
  }

  setKey(String key) async {
    await _mfaDataStorage.write(
        key: SSKMFAData.mfadataKey.toString(), value: key);
  }

  setClientId(String clientId) async {
    await _mfaDataStorage.write(
        key: SSKMFAData.mfadataClientId.toString(), value: clientId);
  }

  setTabId(String tabId) async {
    await _mfaDataStorage.write(
        key: SSKMFAData.mfadataTabId.toString(), value: tabId);
  }

  Future<String> getRealmId() async {
    final String realmId =
        await _mfaDataStorage.read(key: SSKMFAData.mfadataRealmId.toString()) ??
            '';
    return realmId;
  }

  Future<String> getKey() async {
    final String key =
        await _mfaDataStorage.read(key: SSKMFAData.mfadataKey.toString()) ?? '';
    return key;
  }

  Future<String> getClientId() async {
    final String clientId = await _mfaDataStorage.read(
            key: SSKMFAData.mfadataClientId.toString()) ??
        '';
    return clientId;
  }

  Future<String> getTabId() async {
    final String tabId =
        await _mfaDataStorage.read(key: SSKMFAData.mfadataTabId.toString()) ??
            '';
    return tabId;
  }
}
