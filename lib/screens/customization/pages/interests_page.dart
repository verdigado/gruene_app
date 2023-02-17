import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InterestsPage extends StatefulWidget {
  PageController controller;

  InterestsPage(this.controller, {super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('InterestsPage'),
    );
  }
}
