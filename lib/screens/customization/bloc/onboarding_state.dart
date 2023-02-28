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
  final Set<Topic> topis;
  final Set<Subject> subject;

  OnboardingReady({
    required this.topis,
    required this.subject,
  });

  @override
  List<Object?> get props => [topis, subject];
}

class OnboardingSended extends OnboardingState {
  final List<Topic> selectTopis;
  final List<Subject> selectSubject;
  OnboardingSended({
    required this.selectTopis,
    required this.selectSubject,
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
