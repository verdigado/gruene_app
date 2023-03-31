import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gruene_app/constants/theme_data.dart';
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
    controller.addListener(() {
      setState(() {
        if (controller.page != null) {
          currentPage = controller.page?.toInt() ?? 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
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

  Widget getAppBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.keyboard_backspace,
            color: darkGrey,
            size: 50,
          ),
          onPressed: () => controller.previousPage(
              duration: const Duration(milliseconds: 700),
              curve: Curves.linear),
        ),
        progressIndicator(context, 3),
      ],
    );
  }

  Widget progressIndicator(BuildContext context, int stepLength) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              textAlign: TextAlign.right,
              '${AppLocalizations.of(context)?.step} ${currentPage == 0 ? 1 : currentPage} ${AppLocalizations.of(context)?.stepOf} $stepLength',
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeIn,
                tween: Tween<double>(
                  begin: currentPage / stepLength,
                  end: getProgressOfCurrentPage(stepLength),
                ),
                builder: (context, value, _) => LinearProgressIndicator(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.secondary),
                      value: value,
                    )),
          ),
        ],
      ),
    );
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
