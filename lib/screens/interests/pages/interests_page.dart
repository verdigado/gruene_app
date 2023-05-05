import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/net/interests/bloc/interests_bloc.dart';
import 'package:gruene_app/widget/topic_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestsPage extends StatelessWidget {
  const InterestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.interestsPageHeadline1,
              style: Theme.of(context).primaryTextTheme.displayMedium,
            ),
          ),
        ),
        BlocBuilder<InterestsBloc, InterestsState>(
          builder: (context, state) {
            if (state is InterestsLoading) {
              return const CircularProgressIndicator();
            }
            if (state is InterestsReady) {
              return Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  children: state.topics
                      .map((e) => TopicCard(
                            key: Key('TopicCard_${e.id}'),
                            id: e.id,
                            imgageUrl: e.imageUrl,
                            topic: e.name,
                            checked: e.checked,
                            onTap: (check, id) => check
                                ? BlocProvider.of<InterestsBloc>(context)
                                    .add(InterestsTopicAdd(id: id))
                                : BlocProvider.of<InterestsBloc>(context)
                                    .add(InterestsTopicRemove(id: id)),
                          ))
                      .toList(),
                ),
              );
            }
            return Center(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () =>
                        context.read<InterestsBloc>().add(InterestsLoad()),
                    icon: const Icon(Icons.refresh_outlined),
                  ),
                  Text(AppLocalizations.of(context)!.refresh)
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
