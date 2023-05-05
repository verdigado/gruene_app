import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/lists/costume_separated_list.dart';

void main() {
  // CostumeSeparatedList
  testWidgets('CostumeSeparatedList test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CostumeSeparatedList(
            items: [
              CostumeListItem(
                titel: 'Titel',
                iconLeading: Icons.ac_unit,
                spaceBetween: true,
                iconTralling: Icons.ac_unit,
                bold: true,
                linksTo: 'linksTo',
                subtitel: 'subtitel',
                divider: true,
                modalBuilder: (context) => Container(),
                modalSheet: () async {},
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CostumeListItem), findsOneWidget);
  });
}
