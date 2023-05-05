import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/net/interests/bloc/interests_bloc.dart';
import 'package:gruene_app/net/interests/data/competence.dart';
import 'package:gruene_app/net/interests/data/subject.dart';
import 'package:gruene_app/net/interests/data/topic.dart';
import 'package:gruene_app/net/interests/repository/interests_repository.dart';
import 'package:gruene_app/screens/interests/interest_pages_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/screens/interests/pages/interests_page.dart';
import 'package:gruene_app/widget/steppers/page_stepper.dart';
import 'package:gruene_app/widget/topic_card.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

void main() {
  const double PORTRAIT_WIDTH = 1080.0;
  const double PORTRAIT_HEIGHT = 2160.0;
  group('Interests', () {
    tearDown(() async {
      resetMocktailState();
    });
    testWidgets('InterestsPage', (tester) async {
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
            imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png'),
        Topic(
            id: "8",
            name: "Flutter",
            imageUrl: 'assets/images/Sonnenblume_rgb_aufTransparent.png')
      };
      final TestWidgetsFlutterBinding binding =
          TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      MockInterestsRepository interestsRepositoryMock =
          MockInterestsRepository();
      when(() => interestsRepositoryMock.listTopic()).thenReturn(topics);
      when(() => interestsRepositoryMock.listCompetenceAndSubject()).thenAnswer(
          (invocation) => Future.value(InterestsListResult({}, {})));
      final bloc = InterestsBloc(interestsRepositoryMock);
      var stepper = PageStepper(
        onlyNextBtn: true,
        onLastPage: () {},
        pages: const [
          InterestsPage(),
        ],
      );
      await tester.pumpWidget(makeTestWidget(stepper, bloc));
      bloc.add(InterestsLoad());

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
          await tester.drag(find.byKey(const Key('Interests_PageView')),
              const Offset(0.0, -150));
          await tester.pumpAndSettle();
        }
      }
      /* bloc.add(InterestsDone());
      await tester.pumpAndSettle();
      verify(
        () => interestsRepositoryMock.interestsSend(
          any(that: containsAll(topics.map((e) => e.copyWith(checked: true)))),
          any(),
          any(),
        ),
      );
      await tester.pumpAndSettle(); */
    });
  });
}

Widget makeTestWidget(Widget child, InterestsBloc bloc) {
  return MaterialApp(
    home: Scaffold(
      body: BlocProvider(
        create: (context) => bloc,
        child: Provider(
          create: (_) =>
              const ImageProviderDelegate(typ: ImageProviderTyp.asset),
          child: child,
        ),
      ),
    ),
    theme: rootTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

class MockInterestsRepository extends Mock implements InterestsRepository {}
