import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/onboarding/bloc/onboarding_bloc.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
import 'package:gruene_app/net/onboarding/data/topic.dart';
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';
import 'package:gruene_app/screens/onboarding/onboarding_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/widget/topic_card.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

void main() {
  group('Onboarding', () {
    tearDown(() async {
      resetMocktailState();
    });
    testWidgets(
        'should_send_all_interessets_And_Subjects_when_check_all_interessets_And_Subjects',
        (tester) async {
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
      MockOnboardingRepository onboardingRepositoryMock =
          MockOnboardingRepository();
      when(() => onboardingRepositoryMock.listTopic()).thenReturn(topics);
      when(() => onboardingRepositoryMock.listSubject()).thenReturn(subjects);
      when(() => onboardingRepositoryMock.onboardingSend(any(), any()))
          .thenReturn(true);
      final bloc = OnboardingBloc(onboardingRepositoryMock);

      await tester.pumpWidget(makeTestWidget(const OnboardingLayout(), bloc));
      bloc.add(OnboardingLoad());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('intro_page_next_step')));
      // Because of the PageTransition Animation we need to wait for 1 seconds
      await tester.pumpAndSettle();
      for (var topic in topics) {
        final topicCardKey = Key('TopicCard_${topic.id}');
        await tester.tap(find.byKey(topicCardKey));
        final topicCard =
            tester.state(find.byKey(topicCardKey)) as TopicCardState;

        expect(topicCard.checkedState, true);

        await tester.pump();
        // The grid is 2 x 2 this is the reason that we scroll on every second Card
        if (int.parse(topic.id) % 2 == 0) {
          await tester.drag(find.byKey(const Key('Onboarding_PageView')),
              const Offset(0.0, -400));
          await tester.pump();
        }
      }
      await tester.tap(find.byKey(const Key('interests_page_next_step')));
      await tester.pumpAndSettle();
      for (var sub in subjects) {
        await tester.tap(find.widgetWithText(ListTile, sub.name));
      }
      await tester.pump();
      bloc.add(OnboardingDone());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      verify(
        () => onboardingRepositoryMock.onboardingSend(
          any(that: containsAll(topics)),
          any(that: containsAll(subjects)),
        ),
      );
      verify(
        () => onboardingRepositoryMock.listTopic(),
      ).called(1);
      verify(
        () => onboardingRepositoryMock.listSubject(),
      ).called(1);
    });

    testWidgets(
        'should_send_first_interessets_And__first_Subjects_when_check_first_interessets_And_Subjects',
        (tester) async {
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
      };
      Set<Subject> subjects = {
        Subject(id: '1', name: 'Test1'),
        Subject(id: '2', name: 'Test2'),
        Subject(id: '3', name: 'Test3')
      };
      MockOnboardingRepository onboardingRepositoryMock =
          MockOnboardingRepository();
      when(() => onboardingRepositoryMock.listTopic()).thenReturn(topics);
      when(() => onboardingRepositoryMock.listSubject()).thenReturn(subjects);
      when(() => onboardingRepositoryMock.onboardingSend(any(), any()))
          .thenReturn(true);
      final bloc = OnboardingBloc(onboardingRepositoryMock);

      await tester.pumpWidget(makeTestWidget(const OnboardingLayout(), bloc));
      bloc.add(OnboardingLoad());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('intro_page_next_step')));
      // Because of the PageTransition Animation we need to wait for 1 seconds
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final topicCardKey = find.byKey(Key('TopicCard_${topics.first.id}'));
      await tester.tap(topicCardKey);
      await tester.pump();
      var state = tester.state(topicCardKey) as TopicCardState;
      expect(state.checkedState, true);
      // The grid is 2 x 2 this is the reason that we scroll on every second Card
      await tester.tap(find.byKey(const Key('interests_page_next_step')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.widgetWithText(ListTile, subjects.first.name));

      await tester.pump();
      bloc.add(OnboardingDone());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      verify(
        () => onboardingRepositoryMock.onboardingSend(
          any(that: containsAllInOrder([topics.first])),
          any(that: containsAllInOrder([subjects.first])),
        ),
      );
      verify(
        () => onboardingRepositoryMock.listTopic(),
      ).called(1);
      verify(
        () => onboardingRepositoryMock.listSubject(),
      ).called(1);
    });
  });
}

Widget makeTestWidget(Widget child, OnboardingBloc bloc) {
  return MaterialApp(
    home: BlocProvider(
      create: (context) => bloc,
      child: Provider(
        create: (_) => const ImageProviderDelegate(typ: ImageProviderTyp.asset),
        child: child,
      ),
    ),
    theme: rootTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

class MockOnboardingRepository extends Mock implements OnboardingRepository {}
