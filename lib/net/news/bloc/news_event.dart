part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class InitalNewsLoading extends Equatable {
  @override
  List<Object> get props => [];
}

class NextNewsChunk extends Equatable {
  @override
  List<Object> get props => [];
}
