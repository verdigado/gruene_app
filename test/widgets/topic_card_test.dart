import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/widget/topic_card.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('TopicCard widget test create', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Provider(
            create: (_) =>
                const ImageProviderDelegate(typ: ImageProviderTyp.asset),
            child: const TopicCard(
              id: 'test',
              imgageUrl: 'test',
              topic:
                  'https://www.zg.ch/behoerden/baudirektion/arv/natur-landschaft/landschaft_block_1/@@images/2fd8ba74-45ce-4b97-a60e-5c4ea13d2390.jpeg',
            ),
          ),
        ),
      ),
    );
    expect(find.byType(TopicCard), findsOneWidget);
  });
}
