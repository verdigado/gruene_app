import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/interests/bloc/interests_bloc.dart';
import 'package:gruene_app/net/interests/data/subject.dart';
import 'package:gruene_app/routing/routes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/widget/searchable_list.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) async {
        final currentState = state;
        if (currentState is OnboardingSended) {
          if (currentState.navigateToNext) {
            context.go(notification);
          }
        }
        if (currentState is OnboardingSendFailure) {
          MyApp.scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
              duration: const Duration(seconds: 2),
              content: Center(
                child:
                    Text(AppLocalizations.of(context)!.errorSendingOnboarding),
              )));
          Future.delayed(
              const Duration(seconds: 3), () => context.go(startScreen));
        }
      },
      child: Column(
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
                  return SearchableList(
                    searchableItemList: toSearchableListItem(state.subject),
                    paddingTralling: 20,
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
                if (state is OnboardingSending) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                return Center(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () => context
                            .read<OnboardingBloc>()
                            .add(OnboardingLoad()),
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                      Text(AppLocalizations.of(context)!.refresh)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<SearchableListItem> toSearchableListItem(Set<Subject> subject) {
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
    // create first letter entry
    SuspensionUtil.setShowSuspensionStatus(items);
    return items;
  }
}
