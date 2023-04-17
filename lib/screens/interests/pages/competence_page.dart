import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/net/interests/bloc/interests_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/net/interests/data/competence.dart';
import 'package:gruene_app/widget/lists/searchable_list.dart';

class CompetencePage extends StatelessWidget {
  const CompetencePage({super.key});

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
          child: BlocBuilder<InterestsBloc, InterestsState>(
            builder: (context, state) {
              if (state is InterestsReady) {
                return SearchableList(
                  showIndexbar: false,
                  searchableItemList: toSearchableListItem(state.competence),
                  onSelect: (com, check) {
                    if (check) {
                      BlocProvider.of<InterestsBloc>(context)
                          .add(CompetenceAdd(id: com.id));
                    } else {
                      BlocProvider.of<InterestsBloc>(context)
                          .add(CompetenceRemove(id: com.id));
                    }
                  },
                );
              }
              if (state is InterestsSending) {
                return const Center(child: CircularProgressIndicator());
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
