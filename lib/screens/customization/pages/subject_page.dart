import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:gruene_app/screens/customization/data/subject.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage(PageController controller, {Key? key}) : super(key: key);

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final subjects = [
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '1', name: 'Asylpolitik'),
    Subject(id: '2', name: 'Bauen'),
    Subject(id: '1', name: 'Europa'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Friedenspolitik'),
    Subject(id: '1', name: 'Gesundheit'),
    Subject(id: '1', name: 'Globalisierung'),
    Subject(id: '1', name: 'Handelsabkommen'),
    Subject(id: '1', name: 'Zeitpolitik'),
  ];
  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: subjects,
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        var name = subjects[index].name;
        return Container(child: Text('$name'));
      },
    );
  }
}
