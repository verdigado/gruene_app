import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/buttons/previous_button.dart';

void main() {
  testWidgets('Previous button test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PreviousButton(
            onClick: () {},
          ),
        ),
      ),
    );

    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_backspace), findsOneWidget);
  });
}
