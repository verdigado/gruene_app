library slider_carousel;

import 'package:flutter/material.dart';

class SliderCarousel extends StatefulWidget {
  // Background Color
  final Color? backgroundColor;

  // Background Image
  final Widget? backgroundImage;

  final Color? controlsBackground;

  // Page List of SliderCarouselPage class
  final List<SliderCarouselPage> pages;

  // Left Side Icon
  final IconData? leftIcon;

  // Right Side Icon
  final IconData? rightIcon;

  // Show "Skip" Button
  final bool showSkipButton;

  // OnSkip callback
  final VoidCallback? onSkip;

  // Animation Duration
  final Duration animationDuration;

  // Icon Size
  final double? iconSize;

  // Icon Color
  final Color? iconColor;

  // Actie Indicator Color
  final Color? activeDotColor;

  // Deactive Indicator Color
  final Color? deactiveDotColor;

  // Show Previous/Next Icons
  final bool? showPrevNextButton;

  // Show Bottom Indicator
  final bool? showIndicator;

  SliderCarousel({
    Key? key,
    required this.pages,
    this.showSkipButton = true,
    this.onSkip,
    this.backgroundColor = Colors.white,
    this.backgroundImage,
    this.controlsBackground = Colors.white,
    this.leftIcon = Icons.arrow_circle_left_rounded,
    this.rightIcon = Icons.arrow_circle_right_rounded,
    this.animationDuration = const Duration(milliseconds: 400),
    this.iconSize = 30,
    this.iconColor = Colors.black,
    this.showPrevNextButton = false,
    this.showIndicator = true,
    this.activeDotColor = Colors.blue,
    this.deactiveDotColor = Colors.grey,
  })  : assert(pages.length <= 12,
            (throw Exception("Page Length Must be less than 12"))),
        super(key: key);
  @override
  State<SliderCarousel> createState() => _SliderCarouselState();
}

class _SliderCarouselState extends State<SliderCarousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  final _curve = Curves.easeInOut;
  final _overlayColor = MaterialStateProperty.all(Colors.transparent);

  _nextPage() {
    _pageController.nextPage(
      duration: widget.animationDuration,
      curve: _curve,
    );
  }

  _previousPage() {
    _pageController.previousPage(
      duration: widget.animationDuration,
      curve: _curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            widget.showSkipButton == false || widget.onSkip == null
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.only(right: 20, top: 15),
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      overlayColor: _overlayColor,
                      onTap: widget.onSkip,
                      child: const Text(
                        "Skip",
                      ),
                    ),
                  ),
            widget.backgroundImage == null
                ? const SizedBox()
                : Expanded(
                    flex: 3,
                    child: widget.backgroundImage!,
                  ),
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                children: widget.pages,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: widget.controlsBackground,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: widget.showPrevNextButton == false
                        ? const SizedBox()
                        : SizedBox(
                            child: currentIndex == 0
                                ? const SizedBox()
                                : InkWell(
                                    overlayColor: _overlayColor,
                                    onTap: _previousPage,
                                    child: Icon(
                                      widget.leftIcon,
                                      size: widget.iconSize,
                                      color: widget.iconColor,
                                    ),
                                  ),
                          ),
                  ),
                  // Next button
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: widget.showPrevNextButton == false
                        ? const SizedBox()
                        : SizedBox(
                            child: currentIndex + 1 == widget.pages.length
                                ? const SizedBox()
                                : InkWell(
                                    overlayColor: _overlayColor,
                                    onTap: _nextPage,
                                    child: Icon(
                                      widget.rightIcon,
                                      size: widget.iconSize,
                                      color: widget.iconColor,
                                    ),
                                  ),
                          ),
                  ),
                ],
              ),
            ),
            widget.showIndicator == false
                ? const SizedBox()
                : SizedBox(
                    height: size.height * 0.07,
                    child: Indicator(
                      pageLength: widget.pages.length,
                      currentIndex: currentIndex,
                      animatioDuration: widget.animationDuration,
                      curve: _curve,
                      activeDotColor: widget.activeDotColor,
                      deactiveDotColor: widget.deactiveDotColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Indicator Class
class Indicator extends StatelessWidget {
  final int pageLength;
  final int currentIndex;
  final Duration? animatioDuration;
  final Curve? curve;
  final Color? activeDotColor;
  final Color? deactiveDotColor;

  const Indicator({
    Key? key,
    required this.pageLength,
    required this.currentIndex,
    required this.animatioDuration,
    required this.curve,
    required this.activeDotColor,
    required this.deactiveDotColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageLength,
        (index) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: animatioDuration!,
              curve: curve!,
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color:
                    index == currentIndex ? activeDotColor : deactiveDotColor,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

// Pages Class
class SliderCarouselPage extends StatelessWidget {
  final String? title;
  final String? body;
  final Widget? image;
  final bool? preserveImageSpace;
  final double? titleFontSize;
  final double? bodyFontSize;
  final FontWeight? titleFontWeight;
  final FontWeight? bodyFontWeight;
  final Color? titleColor;
  final Color? bodyColor;
  final Color backgroundColorImage;
  final Color backgroundColorText;

  const SliderCarouselPage({
    Key? key,
    this.title,
    this.body,
    this.image,
    this.preserveImageSpace = true,
    this.titleFontSize = 22,
    this.bodyFontSize = 16,
    this.titleFontWeight = FontWeight.bold,
    this.bodyFontWeight = FontWeight.normal,
    this.titleColor = Colors.black,
    this.bodyColor = Colors.grey,
    this.backgroundColorText = Colors.transparent,
    this.backgroundColorImage = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image == null && preserveImageSpace == false
            ? const SizedBox()
            : Expanded(
                flex: 10,
                child: Container(
                  color: backgroundColorImage,
                  child: image == null
                      ? const SizedBox(
                          width: double.infinity,
                        )
                      : SizedBox(
                          child: image!,
                        ),
                ),
              ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: backgroundColorText,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Title Text
                  Expanded(
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Body Text
                  Expanded(
                    child: Text(
                      body!,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      textScaleFactor: 0.9,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
