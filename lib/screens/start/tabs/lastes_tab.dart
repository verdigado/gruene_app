import 'package:flutter/widgets.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/net/news/repository/news_repositoty.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LatestTab extends StatefulWidget {
  final GlobalKey<NewsCardPaginationListViewState> listViewKey;
  static const pageSize = 20;
  final repo = NewsRepositoryImpl();

  LatestTab({super.key, required this.listViewKey});

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NewsCardPaginationListView(
      key: widget.listViewKey,
      pageSize: LatestTab.pageSize,
      pagingController: pagingController,
      onBookmarked: (news) {},
      getNews: (pageSize, pagekey) {
        return widget.repo.getNews(pageSize, pagekey, [NewsFilters.latest]);
      },
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
