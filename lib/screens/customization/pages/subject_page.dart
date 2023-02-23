import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/customization/bloc/customization_bloc.dart';
import 'package:gruene_app/screens/customization/data/subject.dart';
import 'package:gruene_app/screens/customization/pages/widget/subject_list.dart';

class SubjectPage extends StatefulWidget {
  final PageController controller;

  const SubjectPage(this.controller, {Key? key}) : super(key: key);

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            'Welche Themen interessieren Dich?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: BlocBuilder<CustomizationBloc, CustomizationState>(
            builder: (context, state) {
              if (state is CustomizationReady) {
                return SubjectList(
                  subjectList: state.subject.toList(),
                  onSelect: (sub, check) {
                    if (check) {
                      BlocProvider.of<CustomizationBloc>(context)
                          .add(CustomizationSubjectAdd(id: sub.id));
                    } else {
                      BlocProvider.of<CustomizationBloc>(context)
                          .add(CustomizationSubjectRemove(id: sub.id));
                    }
                  },
                );
              }
              return state is CustomizationSending
                  ? const Center(child: CircularProgressIndicator())
                  : Container();
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<CustomizationBloc>(context)
                  .add(CustomizationDone());
              context.go(startScreen);
            },
            child: const Text('Weiter', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () => context.go(startScreen),
            child: const Text('Überspringen'))
      ],
    );
  }
}
