import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';

class ContinueBottom extends StatelessWidget {
  const ContinueBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      ElevatedButton(
            onPressed: () => widget.controller.nextPage(
                duration: const Duration(microseconds: 700),
                curve: Curves.easeIn),
            child: const Text('Weiter', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () => context.go(startScreen),
            child: const Text('Überspringen'));
  }
}
