import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/net/onboarding/data/competence.dart';
import 'package:gruene_app/screens/onboarding/pages/widget/button_group.dart';
import 'package:gruene_app/screens/onboarding/pages/widget/searchable_list.dart';

class CompetencePage extends StatelessWidget {
  final PageController controller;

  const CompetencePage(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              AppLocalizations.of(context)!.competenceHeadline1,
              style: Theme.of(context).primaryTextTheme.displayMedium,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingReady) {
                return SearchableList(
                  showIndexbar: false,
                  searchableItemList: toSearchableListItem(state.competence),
                  onSelect: (com, check) {
                    if (check) {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(CompetenceAdd(id: com.id));
                    } else {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(CompetenceRemove(id: com.id));
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
          next: () => controller.nextPage(
              duration: const Duration(microseconds: 700),
              curve: Curves.easeIn),
          nextText: AppLocalizations.of(context)!.next,
          previous: () => controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          previousText: AppLocalizations.of(context)!.skip,
        ),
      ],
    );
  }

  List<SearchableListItem> toSearchableListItem(Set<Competence> subject) {
    final items = subject
        .map((e) =>
            SearchableListItem(id: e.id, name: e.name, checked: e.checked))
        .toList()
      ..sort(
        (a, b) {
          var cmp = a.name.compareTo(b.name);
          if (cmp != 0) return cmp;
          return a.id.compareTo(b.id);
        },
      );
    return items;
  }
}