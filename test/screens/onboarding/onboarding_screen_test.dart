import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
import 'package:gruene_app/net/onboarding/data/topic.dart';
@GenerateNiceMocks([MockSpec<OnboardingRepository>()])
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';
import 'package:gruene_app/screens/onboarding/onboarding_layout.dart';
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
  setUp(() {
    GetIt.instance.registerSingleton(
      instanceName: 'TopicCard',
      ImageProviderDelegate(typ: ImageProviderTyp.asset),
    );
  });
  testWidgets(
      'should_send_all_interessets_And_Subjects_when_check_all_interessets_And_Subjects',
      (tester) async {
    MockOnboardingRepository onboardingRepositoryMock =
        MockOnboardingRepository();
    final bloc = OnboardingBloc(onboardingRepositoryMock);
    when(onboardingRepositoryMock.listTopic()).thenReturn(topics);
    when(onboardingRepositoryMock.listSubject()).thenReturn(subjects);
    await tester.pumpWidget(makeTestWidget(const OnboardingLayout(), bloc));
    bloc.add(OnboardingLoad());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('intro_page_next_step')));
    // Because of the PageTransition Animation we need to wait for 2 seconds
    await tester.pumpAndSettle(const Duration(seconds: 1));
    for (var topic in topics) {
      await tester.tap(find.byKey(Key('TopicCard_${topic.id}')));
      await tester.pump();

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
    bloc.add(OnboardingDone());
    verify(onboardingRepositoryMock.onboardingSend(any, any)).called(1);
  });
}

Widget makeTestWidget(Widget child, OnboardingBloc bloc) {
  return MaterialApp(
    home: BlocProvider(create: (context) => bloc, child: child),
    theme: rootTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}
