import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/widget/button_group.dart';
import 'package:gruene_app/widget/previous_button.dart';
import 'package:gruene_app/widget/progress_stepper.dart';

/**
 * PageStepper:
 * Pageview with a progressbar and a next and previous button
 */

class PageStepper extends StatefulWidget {
  // List of pages to be displayed
  final List<Widget> pages;

  // optional parameters
  // if true, the user can scroll manually
  final bool isManualScrollable;

  // if true, the previous button is hidden
  final bool onlyNextBtn;

  // if true, the progressbar is hidden
  final bool hideProgressbar;

  final VoidCallback onLastPage;

  // constructor
  const PageStepper({
    Key? key,
    required this.pages,
    required this.onLastPage,
    this.isManualScrollable = false,
    this.onlyNextBtn = false,
    this.hideProgressbar = false,
  }) : super(key: key);

  @override
  State<PageStepper> createState() => _PageStepperState();
}

class _PageStepperState extends State<PageStepper> {
  // current page index
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
    return Column(
      children: [
        // Back button:
        PreviousButton(
          onClick: () => controller.previousPage(
              duration: const Duration(milliseconds: 700),
              curve: Curves.linear),
          isHidden: currentPage == 0,
        ),
        // Progressbar:
        // if the progressbar should not be hidden, it is displayed
        if (!widget.hideProgressbar) ...[
          ProgressStepper(
            currentPage: currentPage,
            stepLength: widget.pages.length,
          ),
        ],
        // PageView:
        // the pages are displayed in a PageView
        Expanded(
          child: PageView(
            key: widget.key,
            controller: controller,
            onPageChanged: (value) => setState(() {
              currentPage = value;
            }),
            physics: widget.isManualScrollable
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: widget.pages,
          ),
        ),
        // Next and previous button:
        // if only the "next"-button should be displayed, the previous button is hidden
        ButtonGroupNextPrevious(
          onlyNext: widget.onlyNextBtn,
          nextText: AppLocalizations.of(context)!.next,
          next: (currentPage + 1) == widget.pages.length
              ? widget.onLastPage
              : () => controller.nextPage(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.linear),
          previousText: AppLocalizations.of(context)!.back,
          previous: () => controller.previousPage(
              duration: const Duration(milliseconds: 700),
              curve: Curves.linear),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
