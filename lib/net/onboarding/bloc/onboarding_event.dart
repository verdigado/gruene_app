part of 'onboarding_bloc.dart';

abstract class OnboardingEvent {}

class OnboardingLoad extends OnboardingEvent {}

class OnboardingDone extends OnboardingEvent {}

class OnboardingTopicAdd extends OnboardingEvent {
  String id;
  OnboardingTopicAdd({
    required this.id,
  });
}

class OnboardingTopicRemove extends OnboardingEvent {
  String id;
  OnboardingTopicRemove({
    required this.id,
  });
}

class OnboardingSubjectAdd extends OnboardingEvent {
  String id;
  OnboardingSubjectAdd({
    required this.id,
  });
}

class OnboardingSubjectRemove extends OnboardingEvent {
  String id;
  OnboardingSubjectRemove({
    required this.id,
  });
}
