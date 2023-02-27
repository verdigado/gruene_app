import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () => context.push(intro),
            child: const Text('Start Intro')),
        TextButton(
            onPressed: () => context.push(notification),
            child: const Text('Push Notification')),
        TextButton(
            onPressed: () => context.push(customization),
            child: const Text('Start Customization')),
        const Center(child: Text('StartScreen')),
      ],
    );
  }
}
