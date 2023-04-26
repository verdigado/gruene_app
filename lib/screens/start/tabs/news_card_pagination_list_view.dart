import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:gruene_app/widget/news_card.dart';

class NewsCardPaginationListView extends StatefulWidget {
  final PagingController<int, News> pagingController;
  final void Function(News news) onBookmarked;

  final int pageSize;

  const NewsCardPaginationListView({
    super.key,
    required this.getNews,
    required this.pagingController,
    required this.pageSize,
    required this.onBookmarked,
  });
  final NewsPaginationResult Function(int pageSize, int pagekey) getNews;
  @override
  State<NewsCardPaginationListView> createState() =>
      NewsCardPaginationListViewState();
}

class NewsCardPaginationListViewState
    extends State<NewsCardPaginationListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.pagingController.addPageRequestListener((pageKey) async {
      logger.d(pageKey);
      // TODO: Remove Delay
      await Future.delayed(Duration(seconds: Random().nextInt(6).toInt()),
          () => fetch(widget.pageSize, pageKey));
    });
    super.initState();
  }

  void fetch(int pageSize, int pageKey) {
    try {
      var newItems = widget.getNews(pageSize, pageKey);
      final isLastPage = newItems.news.length < pageSize;
      if (isLastPage) {
        widget.pagingController.appendLastPage(newItems.news);
      } else {
        widget.pagingController.appendPage(newItems.news, newItems.next);
      }
    } catch (err) {
      widget.pagingController.error = err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(
              () => widget.pagingController.refresh(),
            ),
        child: PagedListView(
          pagingController: widget.pagingController,
          physics: const BouncingScrollPhysics(),
          scrollController: _scrollController,
          builderDelegate: PagedChildBuilderDelegate<News>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {
              return NewsCard(
                  onTap: () {
                    print('hi');
                  },
                  bookmarked: item.bookmarked,
                  heroTag: item.titel,
                  news: item,
                  onBookmarked: (news) {
                    widget.onBookmarked(news);
                  });
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
              error: widget.pagingController.error,
              onTryAgain: () => widget.pagingController.refresh(),
            ),
            newPageErrorIndicatorBuilder: (_) => PageErrorIndicator(
              error: widget.pagingController.error,
              onTryAgain: () =>
                  widget.pagingController.retryLastFailedRequest(),
            ),
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text('Kein Einträge gefunden'),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 800), curve: Curves.linear);
  }
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
  const NewsPaginationResult({
    required this.news,
    required this.self,
    required this.next,
    required this.prev,
  });

  const NewsPaginationResult.noItems({
    this.news = const [],
    this.self = 0,
    this.next = 0,
    this.prev = 0,
  });
}

class News {
  final String imageUrl;
  final String typ;
  final String titel;
  final String subtitel;
  final String chipLabel;
  final String newsUrl;
  final bool bookmarked;
  News(
      {required this.imageUrl,
      required this.typ,
      required this.titel,
      required this.subtitel,
      required this.chipLabel,
      required this.newsUrl,
      required this.bookmarked});
}

Iterable<int> get positiveIntegers sync* {
  int i = 0;
  while (true) {
    yield i++;
  }
}
