// create stateless widget which will be used to register the user with the 2FA service via scanning a QR code
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/widget/qr_scanner.dart';

class TwoFactorRegistration extends StatelessWidget {
  // create a variable to store the user's email address
  final String email;

  // create a constructor for the class to assign the email address to the variable
  const TwoFactorRegistration({Key? key, required this.email})
      : super(key: key);

  // build the widget
  @override
  Widget build(BuildContext context) {
    // return a scaffold widget
    return QrScanner(onDetect: (a, b) {
      print(a);
      context.pop();
    });
    // old codeW
    /* Scaffold(
      // set the app bar
      appBar: AppBar(
        // set the title
        title: const Text('Two Factor Registration'),
      ),
      // create a body for the scaffold
      body: Center(
        // create a column widget
        child: Column(
          // set the alignment of the column
          mainAxisAlignment: MainAxisAlignment.center,
          // set the children of the column
          children: [
            TextButton(onPressed: () => context.push(location)), child: child)
          ],
        ),
      ),
    ); */
  }
}
