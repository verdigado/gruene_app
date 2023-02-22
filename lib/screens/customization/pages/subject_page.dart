import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/customization/data/subject.dart';
import 'package:gruene_app/screens/customization/pages/widget/subject_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SubjectPage extends StatefulWidget {
  PageController controller;

  SubjectPage(this.controller, {Key? key}) : super(key: key);

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final subjects = [
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '9', name: 'Außenpolitik'),
    Subject(id: '2', name: 'Bauen'),
    Subject(id: '3', name: 'Europa'),
    Subject(id: '8', name: 'Zeitpolitik'),
    Subject(id: '4', name: 'Friedenspolitik'),
    Subject(id: '5', name: 'Gesundheit'),
    Subject(id: '6', name: 'Globalisierung'),
    Subject(id: '7', name: 'Handelsabkommen'),
    Subject(id: '8', name: 'Handelspolitik'),
    Subject(id: '8', name: 'Hamburgpolitik'),
    Subject(id: '8', name: 'Hamsterpolitik'),
    Subject(id: '8', name: 'Hundepolitik'),
    Subject(id: '8', name: 'Hauspolitik'),
    Subject(id: '8', name: 'Heimpolitik'),
    Subject(id: '8', name: 'Himmelpolitik'),
    Subject(id: '8', name: 'Handpolitik'),
    Subject(id: '8', name: 'Hemdpolitik'),
    Subject(id: '8', name: 'Hallopolitik'),
    Subject(id: '8', name: 'Haarpolitik'),
    Subject(id: '8', name: 'Halspolitik'),
    Subject(id: '8', name: 'Handelspolitik'),
    Subject(id: '9', name: 'Innenpolitik'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SubjectList(
            subjectList: subjects,
            onSelect: (sub, check) {
              print('Select');
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () => widget.controller.nextPage(
                duration: const Duration(microseconds: 700),
                curve: Curves.easeIn),
            child: const Text('Weiter', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () => context.go(startScreen),
            child: const Text('Überspringen'))
      ],
    );
  }
}
