import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/net/news/repository/news_repositoty.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repo;

  List<NewsPaginationResult> bookmark(
      List<NewsPaginationResult> item, String newsId, bool action) {
    var res = [...item];
    res
        .expand((element) => element.news)
        .where((element) => element.id == newsId)
        .forEach((element) {
      element.bookmarked = action;
    });
    return res;
  }

  NewsBloc(this.repo)
      : super(const NewsState(
          latest: [],
          interested: [],
          saved: [],
        )) {
    on<NextNews>((event, emit) {
      var next = repo.getNews(event.pageSize, event.pageKey, event.filters);
      switch (event.filters) {
        case NewsFilters.interest:
          emit(NewsState(
            latest: state.latest,
            interested: [...state.interested, next],
            saved: state.saved,
          ));
          break;
        case NewsFilters.latest:
          emit(NewsState(
            latest: [...state.latest, next],
            interested: state.interested,
            saved: state.saved,
          ));
          break;
        case NewsFilters.saved:
          emit(NewsState(
            latest: state.latest,
            interested: state.interested,
            saved: [...state.saved, next],
          ));
          break;
      }
    });
    on<BookmarkNews>((event, emit) {
      var action = repo.bookmarked(event.id, event.bookmarked);
      var newState = NewsState(
        latest: bookmark(state.latest, event.id, action),
        interested: bookmark(state.interested, event.id, action),
        saved: bookmark(state.saved, event.id, action),
      );

      emit(newState);
    });
    on<NewsFilterChange>((event, emit) {
      var newState = NewsState(
          interested: state.interested,
          latest: state.latest,
          saved: state.saved,
          currentFilter: event.filters);
      emit(newState);
    });
    on<NewsRefresh>((event, emit) {
      switch (event.filters) {
        case NewsFilters.latest:
          var newState = NewsState(
              interested: state.interested,
              latest: state.latest,
              saved: state.saved,
              currentFilter: event.filters);
          emit(newState);
          break;
        case NewsFilters.interest:
          // TODO: Handle this case.
          break;
        case NewsFilters.saved:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
