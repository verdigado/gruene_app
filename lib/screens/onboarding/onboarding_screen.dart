import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/locator.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      SubjectPage(controller)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => locator.get<OnboardingRepository>(),
      child: BlocProvider(
        create: (context) =>
            OnboardingBloc(context.read<OnboardingRepository>())
              ..add(OnboardingLoad()),
        child: SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: currentPage != 0
                ? PreferredSize(
                    preferredSize: const Size(double.infinity, 80),
                    child: AppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      leading: CupertinoNavigationBarBackButton(
                        color: Colors.grey,
                        previousPageTitle: AppLocalizations.of(context)?.back,
                        onPressed: () => controller.jumpToPage(currentPage - 1),
                      ),
                      elevation: 0,
                      leadingWidth: 100,
                      bottom: progressIndicator(context, pages),
                    ),
                  )
                : PreferredSize(
                    preferredSize: const Size(0, 0), child: Container()),
            body: SafeArea(
              child: PageView(
                key: const Key('Onboarding_PageView'),
                controller: controller,
                onPageChanged: (value) => setState(() {
                  currentPage = value;
                }),
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize progressIndicator(BuildContext context, List<Widget> pages) {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.secondary),
                    value: getProgressOfCurrentPage(pages.length - 1)),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${AppLocalizations.of(context)?.step} $currentPage ${AppLocalizations.of(context)?.stepOf} ${pages.length - 1}',
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ));
  }

  double getProgressOfCurrentPage(int pages) {
    return currentPage / pages;
  }
}
