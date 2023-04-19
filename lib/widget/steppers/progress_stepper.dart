import 'package:flutter/material.dart';

///
/// ProgressStepper:
/// A progressbar with a current and total number of steps
///

class ProgressStepper extends StatelessWidget {
  // current page index
  final int currentPage;

  // total number of steps
  final int stepLength;

  // constructor
  const ProgressStepper({
    super.key,
    this.currentPage = 1,
    this.stepLength = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPage > stepLength) {
      throw Exception('Current page is greater than step length');
    }
    if (currentPage < 1) {
      throw Exception('Current page is less than 1');
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Text(
              textAlign: TextAlign.right,
              '${currentPage} / $stepLength',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeIn,
              tween: Tween<double>(
                begin: 0,
                end: currentPage / stepLength,
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
    );
  }
}
