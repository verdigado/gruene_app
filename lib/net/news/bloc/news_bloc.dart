import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gruene_app/net/news/data/news_filters.dart';
import 'package:gruene_app/net/news/repository/news_repositoty.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repo;
  NewsBloc(this.repo)
      : super(const NewsState(
          latest: NewsPaginationResult.noItems(),
          interested: NewsPaginationResult.noItems(),
          saved: NewsPaginationResult.noItems(),
        )) {
    on<NextNews>((event, emit) {
      var next = repo.getNews(event.pageSize, event.pageKey, event.filters);
      switch (event.filters) {
        case NewsFilters.interest:
          emit(NewsState(
              latest: state.latest, interested: next, saved: state.saved));
          break;
        case NewsFilters.latest:
          emit(NewsState(
              latest: next, interested: state.interested, saved: state.saved));
          break;
        case NewsFilters.saved:
          emit(NewsState(
              latest: state.latest, interested: state.interested, saved: next));
          break;
        case NewsFilters.none:
          // TODO: Handle this case.
          break;
      }
    });
    on<BookmarkNews>((event, emit) {
      var newState = NewsState(
          latest: state.latest,
          interested: state.interested,
          index: event.filters,
          saved: state.saved,
          dirty: true);
      emit(newState);
    });
    on<Clean>((event, emit) {
      emit(NewsState(
          latest: state.latest,
          interested: state.interested,
          saved: state.saved,
          dirty: false));
    });
  }
}
