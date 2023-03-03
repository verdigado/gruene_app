import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/locator.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';

import 'package:gruene_app/screens/onboarding/onboarding_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => locator.get<OnboardingRepository>(),
      child: BlocProvider(
          create: (context) =>
              OnboardingBloc(context.read<OnboardingRepository>())
                ..add(OnboardingLoad()),
          child: const OnboardingLayout()),
    );
  }
}
