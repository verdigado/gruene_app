import 'package:flutter/material.dart';
import 'package:gruene_app/main.dart';
import 'package:permission_handler/permission_handler.dart';

void permissonDeniedSnackbar(String message, String permisson) {
  MyApp.scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    content: Column(
      children: [
        Text(' $message $permisson'),
        TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings'),
        )
      ],
    ),
    duration: const Duration(seconds: 6),
  ));
}
