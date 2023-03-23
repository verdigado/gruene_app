import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';

import 'package:gruene_app/screens/onboarding/onboarding_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/screens/onboarding/pages/competence_page.dart';
import 'package:gruene_app/screens/onboarding/pages/interests_page.dart';
import 'package:gruene_app/screens/onboarding/pages/intro_page.dart';
import 'package:gruene_app/screens/onboarding/pages/subject_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late List<Widget> pages;
  int currentPage = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    pages = [
      IntroPage(controller),
      InterestsPage(controller),
      CompetencePage(controller),
      SubjectPage(controller)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // ignore: unnecessary_cast
      create: (context) => OnboardingRepositoryImpl() as OnboardingRepository,
      child: BlocProvider(
        create: (context) =>
            OnboardingBloc(context.read<OnboardingRepositoryImpl>())
              ..add(OnboardingLoad()),
        child: Provider(
          create: (context) =>
              const ImageProviderDelegate(typ: ImageProviderTyp.cached),
          child: const OnboardingLayout(),
        ),
      ),
    );
  }
}
