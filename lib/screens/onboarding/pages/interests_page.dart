import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/screens/onboarding/pages/widget/button_group.dart';
import 'package:gruene_app/widget/topic_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestsPage extends StatelessWidget {
  final PageController controller;

  const InterestsPage(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            AppLocalizations.of(context)!.interestsPageHeadline1,
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
        ),
        BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const CircularProgressIndicator();
            }
            if (state is OnboardingReady) {
              return Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: state.topics
                      .map((e) => TopicCard(
                            key: Key('TopicCard_${e.id}'),
                            id: e.id,
                            imgageUrl: e.imageUrl,
                            topic: e.name,
                            checked: e.checked,
                            onTap: (check, id) => check
                                ? BlocProvider.of<OnboardingBloc>(context)
                                    .add(OnboardingTopicAdd(id: id))
                                : BlocProvider.of<OnboardingBloc>(context)
                                    .add(OnboardingTopicRemove(id: id)),
                          ))
                      .toList(),
                ),
              );
            }
            return Container();
          },
        ),
        ButtonGroupNextPrevious(
          next: () => controller.nextPage(
              duration: const Duration(microseconds: 700),
              curve: Curves.easeIn),
          nextText: AppLocalizations.of(context)!.next,
          previous: () => controller.previousPage(
              duration: const Duration(microseconds: 700),
              curve: Curves.easeIn),
          previousText: AppLocalizations.of(context)!.skip,
        ),
      ],
    );
  }
}
