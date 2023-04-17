part of 'interests_bloc.dart';

abstract class InterestsEvent {}

class InterestsLoad extends InterestsEvent {}

class InterestsDone extends InterestsEvent {
  final bool navigateToNext;
  InterestsDone({
    this.navigateToNext = true,
  });
}

class InterestsTopicAdd extends InterestsEvent {
  String id;
  InterestsTopicAdd({
    required this.id,
  });
}

class InterestsTopicRemove extends InterestsEvent {
  String id;
  InterestsTopicRemove({
    required this.id,
  });
}

class InterestsSubjectAdd extends InterestsEvent {
  String id;
  InterestsSubjectAdd({
    required this.id,
  });
}

class InterestsSubjectRemove extends InterestsEvent {
  String id;
  InterestsSubjectRemove({
    required this.id,
  });
}

class CompetenceAdd extends InterestsEvent {
  String id;
  CompetenceAdd({
    required this.id,
  });
}

class CompetenceRemove extends InterestsEvent {
  String id;
  CompetenceRemove({
    required this.id,
  });
}
