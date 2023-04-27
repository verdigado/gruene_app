part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class NextNews extends NewsEvent {
  final int pageKey;
  final int pageSize;
  final NewsFilters filters;
  const NextNews({
    required this.pageKey,
    required this.pageSize,
    required this.filters,
  });
  @override
  List<Object> get props => [pageKey, pageSize, filters];
}

class BookmarkNews extends NewsEvent {
  final String id;
  final bool bookmarked;
  final NewsFilters filters;
  const BookmarkNews(this.id, this.bookmarked, this.filters);
  @override
  List<Object> get props => [id, bookmarked, filters];
}

class Clean extends NewsEvent {
  @override
  List<Object> get props => [this];
}
