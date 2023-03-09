import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/routing/routes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/screens/onboarding/pages/widget/button_group.dart';
import 'package:gruene_app/screens/onboarding/pages/widget/subject_list.dart';

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
        ButtonGroupNextPrevious(
          next: () {
            BlocProvider.of<OnboardingBloc>(context).add(OnboardingDone());
            context.go(startScreen);
          },
          nextText: AppLocalizations.of(context)!.next,
          previous: () => widget.controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          previousText: AppLocalizations.of(context)!.skip,
        ),
      ],
    );
  }
}
