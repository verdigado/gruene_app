import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/qr_scanner.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const QrScanner())),
            child: const Text('QRScanner')),
        TextButton(
            onPressed: () => context.push(intro),
            child: const Text('Start Intro')),
        TextButton(
            onPressed: () => context.push(notification),
            child: const Text('Push Notification')),
        TextButton(
            onPressed: () => context.push(interests),
            child: const Text('Start Customization')),
        const Center(child: Text('StartScreen')),
      ],
    );
  }
}
