import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/steppers/page_stepper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gruene_app/widget/steppers/progress_stepper.dart';

void main() {
  testWidgets('PageStepper Buttongroup next and previous',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PageStepper(
            pages: const [Text('one'), Text('two')],
            onLastPage: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('one'), findsOneWidget);

    await tester.tap(find.byKey(const Key('ButtonGroupNextButton')));
    await tester.pumpAndSettle();
    expect(find.text('two'), findsOneWidget);

    await tester.tap(find.byKey(const Key('ButtonGroupPreviousButton')));
    await tester.pumpAndSettle();
    expect(find.text('one'), findsOneWidget);
  });

  testWidgets('PageStepper check if progress parameter works (false)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PageStepper(
            hideProgressbar: false,
            pages: const [Text('one')],
            onLastPage: () {},
          ),
        ),
      ),
    );
    expect(find.byType(ProgressStepper), findsOneWidget);
  });

  testWidgets('PageStepper check if progress parameter works (true)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PageStepper(
            hideProgressbar: true,
            pages: const [Text('one')],
            onLastPage: () {},
          ),
        ),
      ),
    );
    expect(find.byType(ProgressStepper), findsNothing);
  });

  testWidgets('PageStepper only next button visible',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PageStepper(
            onlyNextBtn: true,
            pages: const [Text('one')],
            onLastPage: () {},
          ),
        ),
      ),
    );
    expect(find.byKey(const Key('ButtonGroupNextButton')), findsOneWidget);
    expect(find.byKey(const Key('ButtonGroupPreviousButton')), findsNothing);
  });

  testWidgets('PageStepper backButtonTop works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PageStepper(
            pages: const [Text('one'), Text('two')],
            onLastPage: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('one'), findsOneWidget);

    await tester.tap(find.byKey(const Key('ButtonGroupNextButton')));
    await tester.pumpAndSettle();
    expect(find.text('two'), findsOneWidget);

    // await tester.tap(find.byKey(const Key('PageStepperPreviousButtonTop')));
    await tester.tap(find.byIcon(Icons.keyboard_backspace));
    await tester.pumpAndSettle();
    expect(find.text('one'), findsOneWidget);
  });
}
