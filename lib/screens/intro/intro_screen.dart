import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/screens/intro/intro_content_below.dart';
import 'package:gruene_app/widget/modal_top_line.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  final snappingPositions = const [
    SnappingPosition.factor(
      positionFactor: 0.0,
      snappingCurve: Curves.easeOutExpo,
      snappingDuration: Duration(milliseconds: 500),
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
    SnappingPosition.factor(
      positionFactor: 1.0,
      snappingCurve: Curves.bounceOut,
      snappingDuration: Duration(seconds: 1),
      grabbingContentOffset: GrabbingContentOffset.bottom,
    ),
  ];

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late SnappingSheetController snappingSheetController;
  bool first = true;

  @override
  void initState() {
    super.initState();
    snappingSheetController = SnappingSheetController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      firstSnap();
      // executes after build
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SnappingSheet(
            snappingPositions: widget.snappingPositions,
            child: const IntroContentBelow(), // TODO: Add your content here
            grabbingHeight: 75,

            controller: snappingSheetController,
            onSnapStart: (positionData, snappingPosition) {
              setState(() {
                first = false;
              });
            },
            grabbing: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                        alignment: Alignment.topCenter,
                        child: ModalTopLine(color: Colors.white)),
                    Text(
                      'App erkunden',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Erfahre hier, was Dich erwartet.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              ),
            ), // TODO: Add your grabbing widget here,
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: const Text('Content'),
              ), // TODO: Add your sheet content here
            ),
          ),
        ),
      ),
    );
  }

  Future<void> firstSnap() async {
    if (snappingSheetController.isAttached && first) {
      var down = false;
      await Future.delayed(
        const Duration(seconds: 3),
        () {
          if (first) {
            snappingSheetController
                .snapToPosition(const SnappingPosition.factor(
              positionFactor: 0.03,
              snappingCurve: Curves.easeOutExpo,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.top,
            ));
            down = true;
          }
        },
      );
      if (down) {
        Future.delayed(
          const Duration(milliseconds: 800),
          () {
            snappingSheetController.snapToPosition(widget.snappingPositions[0]);
          },
        );
      }
    }
  }
}
