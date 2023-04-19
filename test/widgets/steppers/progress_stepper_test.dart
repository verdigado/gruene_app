import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/steppers/progress_stepper.dart';

void main() {
  testWidgets('ProgressStepper Step 0/3', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressStepper(currentPage: 0, stepLength: 3),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isInstanceOf<Exception>());
  });

  testWidgets('ProgressStepper Step 1/3', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressStepper(currentPage: 1, stepLength: 3),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('2 / 3'), findsNothing);
    expect(find.text('3 / 3'), findsNothing);
  });

  testWidgets('ProgressStepper Step 2/3', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressStepper(currentPage: 2, stepLength: 3),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsNothing);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text('3 / 3'), findsNothing);
  });

  testWidgets('ProgressStepper Step 3/3', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressStepper(currentPage: 3, stepLength: 3),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsNothing);
    expect(find.text('2 / 3'), findsNothing);
    expect(find.text('3 / 3'), findsOneWidget);
  });

  testWidgets('ProgressStepper Step 4/3', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressStepper(currentPage: 4, stepLength: 3),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isInstanceOf<Exception>());
  });
}
