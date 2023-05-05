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
  const BookmarkNews(this.id, this.bookmarked);
  @override
  List<Object> get props => [id, bookmarked];
}

class NewsFilterChange extends NewsEvent {
  final NewsFilters filters;

  const NewsFilterChange(this.filters);
  @override
  List<Object> get props => [filters];
}

class NewsRefresh extends NewsEvent {
  final NewsFilters filters;
  final int pageSize;
  final int pageKey;

  const NewsRefresh(this.filters, this.pageSize, this.pageKey);
  @override
  List<Object> get props => [filters, pageSize, pageKey];
}
