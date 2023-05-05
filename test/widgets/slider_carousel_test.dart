import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:gruene_app/widget/slider_carousel.dart';
import 'package:vector_graphics/vector_graphics.dart';

void main() {
  testWidgets('SliderCarousel', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SliderCarousel(
            pages: [
              SliderCarouselPage(
                image: SvgPicture(
                    AssetBytesLoader(Assets.images.gruenenTopicOekologieSvg)),
                title: 'Title',
                body: 'Body',
              ),
              SliderCarouselPage(
                image: SvgPicture(
                    AssetBytesLoader(Assets.images.gruenenTopicOekologieSvg)),
                title: 'Title',
                body: 'Body',
              ),
              SliderCarouselPage(
                image: SvgPicture(
                    AssetBytesLoader(Assets.images.gruenenTopicOekologieSvg)),
                title: 'Title',
                body: 'Body',
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SliderCarousel), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(Indicator), findsOneWidget);
    expect(find.byType(SliderCarouselPage), findsOneWidget);
  });
}
