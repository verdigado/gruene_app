part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingLoading extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingReady extends OnboardingState {
  final Set<Topic> topics;
  final Set<Subject> subject;
  final Set<Competence> competence;

  const OnboardingReady({
    required this.topics,
    required this.subject,
    required this.competence,
  });

  @override
  List<Object?> get props => [topics, subject, competence];
}

class OnboardingSending extends OnboardingState {
  final List<Topic> selectTopis;
  final List<Subject> selectSubject;
  final List<Competence> competence;
  const OnboardingSending({
    required this.selectTopis,
    required this.selectSubject,
    required this.competence,
  });

  @override
  List<Object?> get props => [runtimeType, selectSubject, selectTopis];
}

class OnboardingSendFailure extends OnboardingState {
  @override
  List<Object?> get props => [runtimeType];
}

class OnboardingFetchFailure extends OnboardingState {
  @override
  List<Object?> get props => [runtimeType];
}

class OnboardingSended extends OnboardingState {
  final bool navigateToNext;

  const OnboardingSended({this.navigateToNext = true});

  @override
  List<Object?> get props => [runtimeType];
}
