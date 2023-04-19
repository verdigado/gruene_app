import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/screens/interests/pages/competence_page.dart';
import 'package:gruene_app/screens/interests/pages/interests_page.dart';
import 'package:gruene_app/screens/interests/pages/subject_page.dart';
import 'package:provider/provider.dart';

import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/net/interests/bloc/interests_bloc.dart';
import 'package:gruene_app/net/interests/repository/interests_repository.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:gruene_app/widget/steppers/page_stepper.dart';

class InterestPagesScreen extends StatelessWidget {
  const InterestPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // ignore: unnecessary_cast
      create: (context) => InterestsRepositoryImpl() as InterestsRepository,
      child: BlocProvider(
        create: (context) => InterestsBloc(context.read<InterestsRepository>())
          ..add(InterestsLoad()),
        child: Provider(
          create: (_) =>
              const ImageProviderDelegate(typ: ImageProviderTyp.cached),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: SafeArea(
                child: InterestStepper(
                    onLastPage: () => context.push(notification)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InterestStepper extends StatelessWidget {
  final VoidCallback onLastPage;
  const InterestStepper({
    super.key,
    required this.onLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return PageStepper(
      onlyNextBtn: true,
      onLastPage: onLastPage,
      pages: const [
        InterestsPage(),
        CompetencePage(),
        SubjectPage(),
      ],
    );
  }
}
