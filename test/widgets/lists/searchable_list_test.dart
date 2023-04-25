import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/lists/searchable_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // searchableListTest
  testWidgets('searchableListTest', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SearchableList(
            searchableItemList: [
              SearchableListItem(id: '0', name: 'one', checked: false),
              SearchableListItem(id: '1', name: 'two', checked: true),
              SearchableListItem(id: '2', name: 'three', checked: false),
              SearchableListItem(id: '3', name: 'four', checked: true),
              SearchableListItem(id: '4', name: 'five', checked: false),
            ],
            onSelect: (a, b) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('one'), findsOneWidget);
    expect(find.text('two'), findsOneWidget);
    expect(find.text('six'), findsNothing);
    // click on searchvalue "one"
    await tester.enterText(find.byType(TextField), 'one');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ConstrainedBox, 'one'));
    await tester.pumpAndSettle();
  });
}
