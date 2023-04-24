import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:gruene_app/widget/news_card.dart';

class LatestTab extends StatefulWidget {
  const LatestTab({super.key});

  @override
  State<LatestTab> createState() => _LatestTabState();
}

class _LatestTabState extends State<LatestTab> {
  late PagingController<int, News> _pagingController;
  static const _pageSize = 5;

  @override
  void initState() {
    // First fetch;

    var first = getNews(_pageSize, 0);
    _pagingController = PagingController<int, News>(firstPageKey: 0);
    _pagingController.appendPage(first.news, first.next);

    _pagingController.addPageRequestListener((pageKey) async {
      var next = await Future.delayed(
          Duration(seconds: Random().nextInt(6).toInt()),
          () => getNews(_pageSize, pageKey));

      _pagingController.appendPage(next.news, next.next);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<News>(
          itemBuilder: (context, item, index) {
            return NewsCard(
                imageUrl: item.imageUrl,
                typ: item.typ,
                titel: item.titel,
                subtitel: item.subtitel,
                chipLabel: item.chipLabel);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class NewsPaginationResult {
  final List<News> news;
  // Pagekey
  final int self;
  final int next;
  final int prev;
  NewsPaginationResult({
    required this.news,
    required this.self,
    required this.next,
    required this.prev,
  });
}

class News {
  final String imageUrl;
  final String typ;
  final String titel;
  final String subtitel;
  final String chipLabel;
  News({
    required this.imageUrl,
    required this.typ,
    required this.titel,
    required this.subtitel,
    required this.chipLabel,
  });
}

Iterable<int> get positiveIntegers sync* {
  int i = 0;
  while (true) {
    yield i++;
  }
}

NewsPaginationResult getNews(
    int pagesize, // TODO: Just for mocking
    int pagekey) {
  return NewsPaginationResult(news: [
    ...positiveIntegers
        .skip(1) // don't use 0
        .take(pagesize) // take 10 numbers
        .map((e) => News(
              imageUrl:
                  'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
              typ: 'Veranstaltung',
              titel: faker.lorem.sentences(3).join(),
              subtitel: faker.lorem.sentences(30).join(),
              chipLabel: 'Kreisverband',
            ))
  ], self: pagekey, next: pagekey + pagesize, prev: pagekey - pagesize);
}
