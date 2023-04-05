import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/widget/modals/modal_top_line.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_graphics/vector_graphics.dart';

import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/screens/intro/intro_content_below.dart';

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
  late CarouselController carouselController;

  bool first = true;
  bool snapIsTop = false;
  int currentStep = 0;
  double sheetHeight = 0.0;
  double titelOpacity = 0;

  @override
  void initState() {
    super.initState();
    snappingSheetController = SnappingSheetController();
    carouselController = CarouselController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstSnap();
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
            grabbing: InkWell(
                onTap: () {
                  if (snapIsTop) {
                    snappingSheetController
                        .snapToPosition(widget.snappingPositions[0]);
                  } else {
                    snappingSheetController
                        .snapToPosition(widget.snappingPositions[1]);
                  }
                },
                child: GrabbingContent(snapIsTop: snapIsTop)),
            sheetBelow: SnappingSheetContent(
              draggable: true,
              sizeBehavior: SheetSizeStatic(size: 350),
              child: sheetContent(context),
            ),
            child: const IntroContentBelow(),
          ),
        ),
      ),
    );
  }

  Widget sheetContent(BuildContext context) {
    final items = getDiscoverItem(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(medium1),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: CarouselSlider.builder(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: double.infinity,
                  initialPage: 0,
                  viewportFraction: 1,
                  reverse: false,
                  autoPlay: snapIsTop,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentStep = index;
                    });
                  },
                ),
                itemCount: items.length,
                itemBuilder: (context, index, realIndex) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 12,
                          child: Align(
                              alignment: Alignment.center,
                              child: items[index].img)),
                      const Spacer(),
                      Flexible(
                        flex: 8,
                        child: Visibility.maintain(
                          visible: sheetHeight > 0.5,
                          child: AnimatedOpacity(
                            opacity: titelOpacity,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                            child: Text(
                              textAlign: TextAlign.left,
                              items[index].titel,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 4,
                        child: Visibility.maintain(
                          visible: snapIsTop,
                          child: AnimatedOpacity(
                            opacity: snapIsTop ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                            child: Text(
                              items[index].subtitel,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned.fill(
                bottom: 50,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility.maintain(
                    visible: snapIsTop,
                    child: AnimatedOpacity(
                      opacity: snapIsTop ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: StepProgressIndicator(
                          totalSteps: items.length,
                          customColor: (i) =>
                              i == currentStep ? Colors.white : darkGreen,
                          currentStep: currentStep,
                          onTap: (i) {
                            return () {
                              setState(() {
                                currentStep = i;
                              });
                              carouselController.jumpToPage(i);
                            };
                          },
                        ),
                      ),
                    ),
                  ),
                ))
          ],
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
            if (mounted == false) return;
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

class GrabbingContent extends StatelessWidget {
  final bool snapIsTop;
  const GrabbingContent({super.key, this.snapIsTop = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: snapIsTop
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
              AppLocalizations.of(context)!.snapTeaser,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context)!.snapTeaserSubtitel,
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

List<DiscoverItem> getDiscoverItem(BuildContext context) => [
      DiscoverItem(
        titel: AppLocalizations.of(context)!.discoverItemTitel1,
        subtitel: AppLocalizations.of(context)!.discoverItemSubtitel1,
        img: SvgPicture(AssetBytesLoader(Assets.images.womanSofa)),
      ),
      DiscoverItem(
        titel: AppLocalizations.of(context)!.discoverItemTitel1,
        subtitel: AppLocalizations.of(context)!.discoverItemSubtitel1,
        img: SvgPicture(AssetBytesLoader(Assets.images.bicycleMan)),
      ),
      DiscoverItem(
        titel: AppLocalizations.of(context)!.discoverItemTitel1,
        subtitel: AppLocalizations.of(context)!.discoverItemSubtitel1,
        img: SvgPicture(AssetBytesLoader(Assets.images.userGroup)),
      ),
      DiscoverItem(
        titel: AppLocalizations.of(context)!.discoverItemTitel1,
        subtitel: AppLocalizations.of(context)!.discoverItemSubtitel1,
        img: SvgPicture(AssetBytesLoader(Assets.images.userPhone)),
      ),
      DiscoverItem(
        titel: AppLocalizations.of(context)!.discoverItemTitel1,
        subtitel: AppLocalizations.of(context)!.discoverItemSubtitel1,
        img: SvgPicture(AssetBytesLoader(Assets.images.manSitting)),
      )
    ];
