import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/buttons/button_group.dart';

void main() {
  // create buttongroup widget test
  testWidgets('ButtonGroupNextPrevious test', (WidgetTester tester) async {
    // create buttongroup widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonGroupNextPrevious(
            next: () {},
            previous: () {},
          ),
        ),
      ),
    );
    // check if buttongroup widget is created
    expect(find.byType(ButtonGroupNextPrevious), findsOneWidget);
    // check if buttongroup widget has two buttons
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('ButtonGroupNextPrevious only next Button',
      (WidgetTester tester) async {
    // create buttongroup widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonGroupNextPrevious(
            onlyNext: true,
            next: () {},
            previous: () {},
          ),
        ),
      ),
    );
    // check if buttongroup widget is created
    expect(find.byType(ButtonGroupNextPrevious), findsOneWidget);
    // check if buttongroup widget has only next button
    expect(find.byType(ElevatedButton), findsNWidgets(1));
    expect(find.byKey(const Key('ButtonGroupNextButton')), findsOneWidget);
    expect(find.byKey(const Key('ButtonGroupPreviousButton')), findsNothing);
  });
}
