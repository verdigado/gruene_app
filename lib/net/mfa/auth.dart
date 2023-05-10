import 'dart:io';
import 'package:gruene_app/classes/mfa/mfadata.dart';
import 'package:gruene_app/classes/mfa/mfakeys.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:gruene_app_auth_client_api/gruene_app_auth_client_api.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const clientId = 'gruene_app';

void registerMFADevice(
    /* String realmId, String key, String clientId, String tabId */) async {
  String? deviceId;

  if (Platform.isAndroid) {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      throw Exception('Failed to get deviceId. $e');
    }
  } else if (Platform.isIOS) {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      throw Exception('Failed to get deviceId. $e');
    }
  } else {
    throw Exception('Failed to get deviceId. Platform not supported.');
  }

  final api = GrueneAppAuthClientApi(basePathOverride: '', interceptors: [
    PrettyDioLogger(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
        error: true)
  ]).getAppAuthenticatorApi();
//final String registrationToken = registrationToken_example; // String | Mobile device firebase registration token
  final String deviceOs = Platform.operatingSystem; // String | Device OS

/* final String publicKey = publicKey_example; // String | Base64 encoded public key
final String keyAlgorithm = keyAlgorithm_example; // String | PublicKey algorithm
final String signatureAlgorithm = signatureAlgorithm_example; // String | PublicKey algorithm
const bool granted = true; // bool | Was access granted?
final String signature = signature_example; // String | Signature of the decrypted secret, which was send by keycloak + algorithm
 */
  try {
    final resp = api.realmsRealmIdLoginActionsActionTokenGet(
      realmId: await MFAData().getRealmId(),
      key: await MFAData().getKey(),
      clientId: await MFAData().getClientId(),
      tabId: await MFAData().getTabId(),
      deviceId: deviceId,
      deviceOs: deviceOs,
      //  registrationToken,
      // TODO: Check if a Class is a Problem here, because it creates new instances every time it is called
      publicKey: await MFA().getPublicKey(),
      keyAlgorithm: 'RSA',
      signatureAlgorithm: 'SHA512withRSA',
    );
  } on DioError catch (e) {
    print(
        "Exception when calling AppAuthenticatorApi->realmsRealmIdLoginActionsActionTokenGet: $e\n");
  }
}

void approveMFAChallenge() {}

void denyMFAChallenge() {}

void getMFAChallenge() async {
  String? deviceId;

  if (Platform.isAndroid) {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      throw Exception('Failed to get deviceId. $e');
    }
  } else if (Platform.isIOS) {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } catch (e) {
      throw Exception('Failed to get deviceId. $e');
    }
  } else {
    throw Exception('Failed to get deviceId. Platform not supported.');
  }

  final api = GrueneAppAuthClientApi(basePathOverride: '', interceptors: [
    PrettyDioLogger(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
        error: true)
  ]).getAppAuthenticatorChallengeApi();

  try {
    final resp = api.realmsRealmIdChallengeResourceDeviceIdGet(
      realmId: await MFAData().getRealmId(),
      deviceId: deviceId ?? '',
      signature: MFA().sign('test').toString(),
    );
  } on DioError catch (e) {
    print(
        "Exception when calling AppAuthenticatorApi->realmsRealmIdLoginActionsActionTokenGet: $e\n");
  }
}
