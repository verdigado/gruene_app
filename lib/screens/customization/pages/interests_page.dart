import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gruene_app/widget/topic_card.dart';

class InterestsPage extends StatefulWidget {
  PageController controller;

  InterestsPage(this.controller, {super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        TopicCard(),
        TopicCard(),
        TopicCard(),
        TopicCard(),
        TopicCard(),
        TopicCard(),
        TopicCard(),
      ],
    );
  }
}
