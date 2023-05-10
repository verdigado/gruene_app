// create stateless widget which will be used to register the user with the 2FA service via scanning a QR code

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/classes/mfa/mfadata.dart';
import 'package:gruene_app/widget/qr_scanner.dart';

class TwoFactorRegistration extends StatelessWidget {
  // create a variable to store the user's email address
  bool lock = false;

  // create a constructor for the class to assign the email address to the variable
  TwoFactorRegistration({Key? key}) : super(key: key);

  // build the widget
  @override
  Widget build(BuildContext context) {
    // return a scaffold widget
    return QrScanner(onDetect: (a, b) {
      if (!lock) {
        //decode the barcode and get the url, key, client id and tab id
        final uri = Uri.tryParse(a.barcodes.first.displayValue ?? '');
        if (uri == null) return;
        if (uri.queryParameters['client_id'] != null &&
            uri.queryParameters['key'] != null &&
            uri.queryParameters['tab_id'] != null) {
          MFAData().setRealmId(
              'https://saml.gruene.de/realms/gruene-app-test/login-actions/action-token');
          MFAData().setClientId(uri.queryParameters['client_id']!);
          MFAData().setKey(uri.queryParameters['key']!);
          MFAData().setTabId(uri.queryParameters['tab_id']!);
        }
        context.pop();
        lock = true;
      }
    });
  }
}
