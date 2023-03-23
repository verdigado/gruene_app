import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gruene_app/screens/onboarding/pages/competence_page.dart';
import 'package:gruene_app/screens/onboarding/pages/interests_page.dart';
import 'package:gruene_app/screens/onboarding/pages/intro_page.dart';
import 'package:gruene_app/screens/onboarding/pages/subject_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingLayout extends StatefulWidget {
  const OnboardingLayout({super.key});

  @override
  State<OnboardingLayout> createState() => _OnboardingLayoutState();
}

class _OnboardingLayoutState extends State<OnboardingLayout> {
  int currentPage = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: PageView(
            key: const Key('Onboarding_PageView'),
            controller: controller,
            onPageChanged: (value) => setState(() {
              currentPage = value;
            }),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              IntroPage(controller),
              InterestsPage(
                controller,
                progressbar: getAppBar(context),
              ),
              CompetencePage(
                controller,
                progressbar: getAppBar(context),
              ),
              SubjectPage(
                controller,
                progressbar: getAppBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: CupertinoNavigationBarBackButton(
        color: Colors.grey,
        previousPageTitle: AppLocalizations.of(context)?.back,
        onPressed: () => controller.previousPage(
            duration: const Duration(milliseconds: 700), curve: Curves.linear),
      ),
      elevation: 0,
      leadingWidth: 100,
      bottom: progressIndicator(context, 3),
    );
  }

  PreferredSize progressIndicator(BuildContext context, int stepLength) {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: currentPage.floorToDouble(),
                      end: getProgressOfCurrentPage(stepLength),
                    ),
                    builder: (context, value, _) => LinearProgressIndicator(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.secondary),
                        value: value)),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${AppLocalizations.of(context)?.step} $currentPage ${AppLocalizations.of(context)?.stepOf} $stepLength',
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
