import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/net/news/bloc/news_bloc.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/screens/start/start_screen.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LatestTab extends StatefulWidget {
  final GlobalKey<NewsCardPaginationListViewState> listViewKey;
  static const pageSize = 20;

  const LatestTab({super.key, required this.listViewKey});

  @override
  State<LatestTab> createState() => _LatestTabState();
}

class _LatestTabState extends State<LatestTab>
    with AutomaticKeepAliveClientMixin<LatestTab> {
  late PagingController<int, News> pagingController;
  @override
  void initState() {
    pagingController = PagingController<int, News>(
        firstPageKey: 0, invisibleItemsThreshold: LatestTab.pageSize ~/ 2);
    pagingController.addPageRequestListener((pageKey) async {
      logger.d(pageKey);
      await Future.delayed(Duration(seconds: Random().nextInt(6).toInt()),
          () => fetch(LatestTab.pageSize, pageKey));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<NewsBloc, NewsState>(
      listener: (context, state) {
        try {
          var newItems = state.latest;
          apppend(newItems, pagingController);
        } catch (err) {
          pagingController.error = err;
        }
      },
      child: NewsCardPaginationListView(
        key: widget.listViewKey,
        pageSize: LatestTab.pageSize,
        pagingController: pagingController,
        onBookmarked: (news) {
          context.read<NewsBloc>().add(
                BookmarkNews(news.id, !news.bookmarked),
              );
        },
      ),
    );
  }

  void fetch(int pageSize, int pageKey) {
    context.read<NewsBloc>().add(NextNews(
        pageKey: pageKey, pageSize: pageSize, filters: NewsFilters.latest));
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
