import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';

import 'package:gruene_app/screens/onboarding/onboarding_layout.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
              child: const OnboardingLayout())),
    );
  }
}
