import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:gruene_app/widget/news_card.dart';

class LatestTab extends StatefulWidget {
  const LatestTab({super.key});

  @override
  State<LatestTab> createState() => LatestTabState();
}

class LatestTabState extends State<LatestTab>
    with AutomaticKeepAliveClientMixin<LatestTab> {
  final PagingController<int, News> _pagingController =
      PagingController<int, News>(
          firstPageKey: 1, invisibleItemsThreshold: _pageSize ~/ 2);
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;

  @override
  void initState() {
    // First fetch;

    _pagingController.addPageRequestListener((pageKey) async {
      print(pageKey);
      await Future.delayed(
          Duration(seconds: Random().nextInt(6).toInt()), () => fetch(pageKey));
    });
    super.initState();
  }

  void fetch(int pageKey) {
    try {
      var newItems = getNews(_pageSize, pageKey);
      final isLastPage = newItems.news.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.news);
      } else {
        _pagingController.appendPage(newItems.news, newItems.next);
      }
    } catch (err) {
      _pagingController.error = err;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
        child: PagedListView(
          pagingController: _pagingController,
          physics: const BouncingScrollPhysics(),
          scrollController: _scrollController,
          builderDelegate: PagedChildBuilderDelegate<News>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {
              return NewsCard(
                  onTap: () {
                    print('hi');
                  },
                  heroTag: item.titel,
                  imageUrl: item.imageUrl,
                  typ: item.typ,
                  titel: item.titel,
                  subtitel: item.subtitel,
                  chipLabel: item.chipLabel);
            },
            newPageProgressIndicatorBuilder: (context) => SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
            ),
            firstPageProgressIndicatorBuilder: (context) => SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
            ),
            noMoreItemsIndicatorBuilder: (context) => Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset(
                    Assets.images.sonnenblumeRgbAufTransparent.path),
              ),
            ),
            firstPageErrorIndicatorBuilder: (_) => PageErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.refresh(),
            ),
            newPageErrorIndicatorBuilder: (_) => PageErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.retryLastFailedRequest(),
            ),
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text('Kein Einträge gefunden'),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 800), curve: Curves.linear);
  }

  @override
  bool get wantKeepAlive => true;
}

class PageErrorIndicator extends StatelessWidget {
  final void Function() onTryAgain;

  final dynamic error;

  const PageErrorIndicator(
      {super.key, required this.onTryAgain, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Retry',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
        ),
        IconButton(
          onPressed: () => onTryAgain(),
          icon: const Icon(
            Icons.refresh_outlined,
            size: 35,
          ),
        ),
      ],
    );
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

NewsPaginationResult getNews(int pagesize, int pagekey) {
  if (pagekey > 100) {
    return NewsPaginationResult(news: [
      News(
        imageUrl:
            'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
        typ: 'Veranstaltung',
        titel: faker.lorem.sentences(1).join(),
        subtitel: faker.lorem.sentences(3).join(),
        chipLabel: 'Kreisverband',
      ),
      News(
        imageUrl:
            'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
        typ: 'Veranstaltung',
        titel: faker.lorem.sentences(3).join(),
        subtitel: faker.lorem.sentences(30).join(),
        chipLabel: 'Kreisverband',
      ),
      News(
        imageUrl:
            'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
        typ: 'Veranstaltung',
        titel: faker.lorem.sentences(3).join(),
        subtitel: faker.lorem.sentences(30).join(),
        chipLabel: 'Kreisverband',
      )
    ], self: pagekey, next: pagekey + pagesize, prev: pagekey - pagesize);
  }
  return NewsPaginationResult(news: [
    ...positiveIntegers
        .skip(1) // don't use 0
        .take(pagesize) // take 10 numbers
        .map((e) => News(
              imageUrl:
                  'https://picsum.photos/seed/${Random().nextInt(10000000)}/1000/500',
              typ: 'Veranstaltung',
              titel: faker.lorem.sentences(1).join(),
              subtitel: faker.lorem.sentences(3).join(),
              chipLabel: 'Kreisverband',
            ))
  ], self: pagekey, next: pagekey + pagesize, prev: pagekey - pagesize);
}
