import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/screens/interests/pages/competence_page.dart';
import 'package:gruene_app/screens/interests/pages/interests_page.dart';
import 'package:gruene_app/screens/interests/pages/subject_page.dart';
import 'package:provider/provider.dart';

import '../../common/utils/image_provider_delegate.dart';
import '../../net/interests/bloc/interests_bloc.dart';
import '../../net/interests/repository/interests_repository.dart';
import '../../routing/routes.dart';
import '../../widget/page_stepper.dart';

class InterestPagesScreen extends StatelessWidget {
  const InterestPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // ignore: unnecessary_cast
      create: (context) => OnboardingRepositoryImpl() as OnboardingRepository,
      child: BlocProvider(
        create: (context) =>
            OnboardingBloc(context.read<OnboardingRepository>())
              ..add(OnboardingLoad()),
        child: Provider(
          create: (_) =>
              const ImageProviderDelegate(typ: ImageProviderTyp.cached),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: SafeArea(
                child: PageStepper(
                  onlyNextBtn: true,
                  onLastPage: () => {context.go(startScreen)},
                  pages: const [
                    InterestsPage(),
                    CompetencePage(),
                    SubjectPage(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
