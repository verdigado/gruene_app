import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
import 'package:gruene_app/net/onboarding/data/topic.dart';
@GenerateNiceMocks([MockSpec<OnboardingRepository>()])
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';
import 'package:gruene_app/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_screen_test.mocks.dart';

Set<Topic> topics = {
  Topic(
      id: "1",
      name: "Testen macht Spaß",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
  Topic(
      id: "2",
      name: "Testen",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
  Topic(
      id: "3",
      name: "Flutter",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
  Topic(
      id: "4",
      name: "Flutter",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
  Topic(
      id: "5",
      name: "Flutter",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
  Topic(
      id: "6",
      name: "Flutter",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
  Topic(
      id: "7",
      name: "Flutter",
      imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png')
};
Set<Subject> subjects = {
  Subject(id: '1', name: 'Test1'),
  Subject(id: '2', name: 'Test2'),
  Subject(id: '3', name: 'Test3')
};

void main() {
  OnboardingRepository onboardingRepositoryMock = MockOnboardingRepository();
  setUp(() {
    GetIt.instance.registerSingleton(
      instanceName: 'TopicCard',
      ImageProviderDelegate(typ: ImageProviderTyp.asset),
    );
    GetIt.instance.registerSingleton(onboardingRepositoryMock);
  });
  testWidgets(
      'should_send_all_interessets_And_Subjects_when_check_all_interessets_And_Subjects',
      (tester) async {
    when(onboardingRepositoryMock.listTopic())
        .thenAnswer((realInvocation) => topics);
    when(onboardingRepositoryMock.listSubject())
        .thenAnswer((realInvocation) => subjects);
    await tester.pumpWidget(makeTestWidget(const OnboardingScreen()));
    await tester.tap(find.byKey(const Key('intro_page_next_step')));
    // Because of the PageTransition Animation we need to wait for 3 seconds
    await tester.pumpAndSettle(const Duration(seconds: 2));
    for (var topic in topics) {
      await tester.tap(find.byKey(Key('TopicCard_${topic.id}')));
      await tester.pumpAndSettle();

      // The grid is 2 x 2 this is the reason that we scroll on every second Card
      if (int.parse(topic.id) % 2 == 0) {
        await tester.drag(find.byKey(const Key('Onboarding_PageView')),
            const Offset(0.0, -400));
        await tester.pump();
      }
    }
    await tester.tap(find.byKey(const Key('interests_page_next_step')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    for (var sub in subjects) {
      await tester.tap(find.widgetWithText(ListTile, sub.name));
    }
    await tester.pump();
    await tester.tap(find.byKey(const Key('subject_page_next_step')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}

Widget makeTestWidget(Widget child) {
  return MaterialApp(
    home: child,
    theme: rootTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}
