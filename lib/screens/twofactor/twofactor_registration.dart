// create stateless widget which will be used to register the user with the 2FA service via scanning a QR code
import 'package:flutter/material.dart';

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
    return Scaffold(
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
          children: const [
            // create a text widget to display the instructions
            Text(
              'Scan the QR code below with your 2FA app',
              // set the style of the text
              style: TextStyle(
                // set the font size
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
