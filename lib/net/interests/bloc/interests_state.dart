part of 'interests_bloc.dart';

abstract class InterestsState extends Equatable {
  const InterestsState();
}

class InterestsInitial extends InterestsState {
  @override
  List<Object?> get props => [];
}

class InterestsLoading extends InterestsState {
  @override
  List<Object?> get props => [];
}

class InterestsReady extends InterestsState {
  final Set<Topic> topics;
  final Set<Subject> subject;
  final Set<Competence> competence;

  const InterestsReady({
    required this.topics,
    required this.subject,
    required this.competence,
  });

  @override
  List<Object?> get props => [topics, subject, competence];
}

class InterestsSending extends InterestsState {
  final List<Topic> selectTopis;
  final List<Subject> selectSubject;
  final List<Competence> competence;
  const InterestsSending({
    required this.selectTopis,
    required this.selectSubject,
    required this.competence,
  });

  @override
  List<Object?> get props => [runtimeType, selectSubject, selectTopis];
}

class InterestsSendFailure extends InterestsState {
  @override
  List<Object?> get props => [runtimeType];
}

class InterestsFetchFailure extends InterestsState {
  @override
  List<Object?> get props => [runtimeType];
}

class InterestsSended extends InterestsState {
  final bool navigateToNext;

  const InterestsSended({this.navigateToNext = true});

  @override
  List<Object?> get props => [runtimeType];
}
