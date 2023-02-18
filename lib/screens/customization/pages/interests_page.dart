import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/widget/topic_card.dart';

import '../bloc/costumization_bloc.dart';

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
        BlocBuilder<CostumizationBloc, CostumizationState>(
          builder: (context, state) {
            if (state is CostumizationLoading) {
              return CircularProgressIndicator();
            }
            if (state is CostumizationReady) {
              return Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: state.topis
                      .map((e) => TopicCard(
                            imgageUrl: e.imageUrl,
                            topic: e.name,
                          ))
                      .toList(),
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
