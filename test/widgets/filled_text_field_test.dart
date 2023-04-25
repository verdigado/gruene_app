import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/filled_text_field.dart';

void main() {
  testWidgets('Create filled text field', (WidgetTester tester) async {
    TextEditingController textEditingController = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilledTextField(
            textEditingController: textEditingController,
            labelText: 'test',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FilledTextField), findsOneWidget);
  });

  testWidgets('Filled text field has label', (WidgetTester tester) async {
    TextEditingController textEditingController = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilledTextField(
            textEditingController: textEditingController,
            labelText: 'test',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('test'), findsOneWidget);
  });
}
