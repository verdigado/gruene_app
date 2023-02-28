import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/screens/customization/bloc/onboarding_bloc.dart';
import 'package:gruene_app/screens/customization/pages/widget/subject_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubjectPage extends StatefulWidget {
  final PageController controller;

  const SubjectPage(this.controller, {Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            AppLocalizations.of(context)!.subjectHeadline1,
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
        ),
        Expanded(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingReady) {
                return SubjectList(
                  subjectList: state.subject.toList(),
                  onSelect: (sub, check) {
                    if (check) {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(OnboardingSubjectAdd(id: sub.id));
                    } else {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(OnboardingSubjectRemove(id: sub.id));
                    }
                  },
                );
              }
              return state is OnboardingSending
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
              BlocProvider.of<OnboardingBloc>(context)
                  .add(OnboardingDone());
              context.go(startScreen);
            },
            child: Text(AppLocalizations.of(context)!.next,
                style: const TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () => context.go(startScreen),
            child: Text(AppLocalizations.of(context)!.back))
      ],
    );
  }
}
