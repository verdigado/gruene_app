part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {}

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

  OnboardingReady({
    required this.topics,
    required this.subject,
    required this.competence,
  });

  @override
  List<Object?> get props => [topics, subject, competence];
}

class OnboardingSended extends OnboardingState {
  final List<Topic> selectTopis;
  final List<Subject> selectSubject;
  final List<Competence> competence;
  OnboardingSended({
    required this.selectTopis,
    required this.selectSubject,
    required this.competence,
  });

  @override
  List<Object?> get props => [selectSubject, selectTopis];
}

class OnboardingSendFailure extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingSending extends OnboardingState {
  @override
  List<Object?> get props => [];
}
