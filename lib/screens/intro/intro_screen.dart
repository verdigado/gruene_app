import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:gruene_app/screens/intro/intro_content_below.dart';
import 'package:gruene_app/widget/modal_top_line.dart';

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

class DiscoverItem {
  String titel;
  String subtitel;
  Widget img;
  DiscoverItem({
    required this.titel,
    required this.subtitel,
    required this.img,
  });
}

class _IntroScreenState extends State<IntroScreen> {
  late SnappingSheetController snappingSheetController;
  late CarouselController carouselController;

  bool first = true;
  bool snapIsTop = false;
  int currentStep = 0;
  double sheetHeight = 0.0;
  double titelOpacity = 0;

  final items = [
    DiscoverItem(
      titel: 'Deine Lieblingsnews immer dabei items 0',
      subtitel:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy ut labore hjkwsadf. items 0',
      img: SvgPicture(AssetBytesLoader(Assets.images.womanSofa)),
    ),
    DiscoverItem(
      titel: 'Deine Lieblingsnews immer dabei items 1',
      subtitel:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy ut labore hjkwsadf. items 1',
      img: SvgPicture(AssetBytesLoader(Assets.images.bicycleMan)),
    ),
    DiscoverItem(
      titel: 'Deine Lieblingsnews  dabei items 2',
      subtitel:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy ut labore hjkwsadf. items 2',
      img: SvgPicture(AssetBytesLoader(Assets.images.userGroup)),
    ),
    DiscoverItem(
      titel: 'Deine Lieblingsnews dabei items 3',
      subtitel:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy ut labore hjkwsadf. items 3',
      img: SvgPicture(AssetBytesLoader(Assets.images.userPhone)),
    ),
    DiscoverItem(
      titel: 'Deine Lieblingsnews  items 4',
      subtitel:
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy ut labore hjkwsadf. items 4',
      img: SvgPicture(AssetBytesLoader(Assets.images.manSitting)),
    )
  ];

  @override
  void initState() {
    super.initState();
    snappingSheetController = SnappingSheetController();
    carouselController = CarouselController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            lockOverflowDrag: true,
            onSheetMoved: (positionData) {
              setState(() {
                sheetHeight = positionData.relativeToSheetHeight;
                // Some Space betwin
                if (positionData.relativeToSheetHeight >= 0.50) {
                  titelOpacity = 1.0;
                }
                if (positionData.relativeToSheetHeight >= 0.90) {
                  snapIsTop = true;
                }
                if (positionData.relativeToSheetHeight <= 0.88) {
                  snapIsTop = false;
                }
              });
            },
            snappingPositions: widget.snappingPositions,
            grabbingHeight: 100,
            controller: snappingSheetController,
            onSnapStart: (positionData, snappingPosition) {
              setState(() {
                first = false;
              });
            },
            grabbing: GrabbingContent(snapIsTop: snapIsTop),
            sheetBelow: SnappingSheetContent(
              draggable: true,
              sizeBehavior: SheetSizeStatic(size: 350),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(medium1),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 6,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CarouselSlider(
                            carouselController: carouselController,
                            options: CarouselOptions(
                              height: double.infinity,
                              initialPage: 0,
                              viewportFraction: 1,
                              reverse: false,
                              autoPlay: snapIsTop,
                              autoPlayInterval: const Duration(seconds: 10),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentStep = index;
                                });
                              },
                            ),
                            items: [...items.map((e) => e.img)],
                          ),
                        ),
                      ),
                      Visibility.maintain(
                        visible: snapIsTop,
                        child: AnimatedOpacity(
                          opacity: snapIsTop ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: medium3, top: 12),
                                  child: StepProgressIndicator(
                                    totalSteps: items.length,
                                    customColor: (i) => i == currentStep
                                        ? Colors.white
                                        : darkGrey,
                                    currentStep: currentStep,
                                    onTap: (i) {
                                      return () {
                                        carouselController.jumpToPage(i);
                                        setState(() {
                                          currentStep = i;
                                        });
                                      };
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Transform.rotate(
                                  angle: 3.14,
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.keyboard_backspace_outlined,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        carouselController.nextPage();
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: medium2),
                          child: Visibility.maintain(
                            visible: sheetHeight > 0.5,
                            child: AnimatedOpacity(
                              opacity: titelOpacity,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              child: Text(items[currentStep].titel,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .displayLarge
                                      ?.copyWith(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Visibility.maintain(
                          visible: snapIsTop,
                          child: AnimatedOpacity(
                            opacity: snapIsTop ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                            child: Text(
                              items[currentStep].subtitel,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            child: const IntroContentBelow(),
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

class GrabbingContent extends StatefulWidget {
  bool snapIsTop;
  GrabbingContent({super.key, this.snapIsTop = false});

  @override
  State<GrabbingContent> createState() => _GrabbingContentState();
}

class _GrabbingContentState extends State<GrabbingContent> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: widget.snapIsTop
            ? BorderRadius.zero
            : const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(medium1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
                alignment: Alignment.topCenter,
                child: ModalTopLine(color: Colors.white)),
            Text(
              'App erkunden',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
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
    );
  }
}
