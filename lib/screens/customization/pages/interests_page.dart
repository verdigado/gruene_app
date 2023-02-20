import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/topic_card.dart';

import '../bloc/customization_bloc.dart';

class InterestsPage extends StatefulWidget {
  PageController controller;

  InterestsPage(this.controller, {super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            'Welche Bereiche der Parteiarbeit interessieren Dich besonders?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocBuilder<CustomizationBloc, CustomizationState>(
          builder: (context, state) {
            if (state is CustomizationLoading) {
              return const CircularProgressIndicator();
            }
            if (state is CustomizationReady) {
              return Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: state.topis
                      .map((e) => TopicCard(
                            id: e.id,
                            imgageUrl: e.imageUrl,
                            topic: e.name,
                            onTap: (check, id) => check
                                ? BlocProvider.of<CustomizationBloc>(context)
                                    .add(CustomizationTopicAdd(id: id))
                                : BlocProvider.of<CustomizationBloc>(context)
                                    .add(CustomizationTopicRemove(id: id)),
                          ))
                      .toList(),
                ),
              );
            }
            return Container();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () => widget.controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn),
            child: const Text('Weiter', style: TextStyle(color: Colors.white))),
        TextButton(
            onPressed: () => context.go(startScreen),
            child: const Text('Überspringen'))
      ],
    );
  }
}
