import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/net/news/bloc/news_bloc.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/screens/start/start_screen.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SavedTab extends StatefulWidget {
  static const pageSize = 20;
  final GlobalKey<NewsCardPaginationListViewState> listViewKey;
  const SavedTab({super.key, required this.listViewKey});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab>
    with AutomaticKeepAliveClientMixin<SavedTab> {
  late PagingController<int, News> pagingController;

  @override
  void initState() {
    pagingController = PagingController<int, News>(
        firstPageKey: 0, invisibleItemsThreshold: SavedTab.pageSize ~/ 2);
    pagingController.addPageRequestListener((pageKey) async {
      logger.d(pageKey);
      await Future.delayed(Duration(seconds: Random().nextInt(6).toInt()),
          () => fetch(SavedTab.pageSize, pageKey));
    });
    super.initState();
  }

  void fetch(int pageSize, int pageKey) {
    context.read<NewsBloc>().add(NextNews(
        pageKey: pageKey, pageSize: pageSize, filters: NewsFilters.saved));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<NewsBloc, NewsState>(
      listener: (context, state) {
        try {
          var newItems = state.saved;
          apppend(newItems, pagingController);
        } catch (err) {
          pagingController.error = err;
        }
      },
      child: NewsCardPaginationListView(
        key: widget.listViewKey,
        pageSize: SavedTab.pageSize,
        pagingController: pagingController,
        onBookmarked: (news) {
          context
              .read<NewsBloc>()
              .add(BookmarkNews(news.id, news.bookmarked, NewsFilters.saved));
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
