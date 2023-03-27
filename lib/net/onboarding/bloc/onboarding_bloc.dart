import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/exception/bloc_exception.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/net/onboarding/data/competence.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
import 'package:gruene_app/net/onboarding/data/topic.dart';
import 'package:gruene_app/net/onboarding/repository/onboarding_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingRepository onboardingRepository;

  OnboardingBloc(this.onboardingRepository) : super(OnboardingInitial()) {
    on<OnboardingLoad>((event, emit) {
      emit(OnboardingReady(
          topics: onboardingRepository.listTopic(),
          subject: onboardingRepository.listSubject(),
          competence: onboardingRepository.listCompetence()));
    });
    on<OnboardingTopicAdd>((event, emit) {
      final currentState = state;
      if (currentState is OnboardingReady) {
        currentState.topics
            .where((element) => element.id == event.id)
            .first
            .checked = true;
        emit(OnboardingReady(
          topics: currentState.topics,
          subject: currentState.subject,
          competence: currentState.competence,
        ));
      } else {
        stateError('OnboardingTopicAdd');
      }
    });
    on<OnboardingTopicRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is OnboardingReady) {
          currentState.topics
              .where((element) => element.id != event.id)
              .first
              .checked = false;
          emit(OnboardingReady(
            topics: currentState.topics,
            subject: currentState.subject,
            competence: currentState.competence,
          ));
        } else {
          stateError('OnboardingTopicRemove');
        }
      },
    );
    on<OnboardingSubjectAdd>(
      (event, emit) {
        final currentState = state;
        if (currentState is OnboardingReady) {
          final markedSubject = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          final toAdd = markedSubject.copyWith(checked: true);
          final rest =
              currentState.subject.where((element) => element.id != event.id);
          emit(
            OnboardingReady(
              topics: currentState.topics,
              competence: currentState.competence,
              subject: {toAdd, ...rest},
            ),
          );
        } else {
          stateError('OnboardingSubjectAdd');
        }
      },
    );
    on<OnboardingSubjectRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is OnboardingReady) {
          final markedSubject = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          final toRemove = markedSubject.copyWith(checked: false);
          final rest = currentState.subject
              .where((element) => element.id != event.id)
              .toSet();
          emit(
            OnboardingReady(
                subject: {toRemove, ...rest},
                topics: currentState.topics,
                competence: currentState.competence),
          );
        } else {
          stateError('OnboardingSubjectRemove');
        }
      },
    );

    on<OnboardingDone>(
      (event, emit) {
        // ToDo: Loading State should be implemented
        //emit(OnboardingSending());
        final currentState = state;
        if (currentState is OnboardingReady) {
          final sub =
              currentState.subject.where((element) => element.checked).toList();
          final topic =
              currentState.topics.where((element) => element.checked).toList();
          final competence = currentState.competence
              .where((element) => element.checked)
              .toList();
          logger.i(jsonEncode({
            'selectedTopics': topic,
            'selectedSubjects': sub,
            'selectedCompetence': competence
          }));
          if (onboardingRepository.onboardingSend(topic, sub, competence)) {
            final sendEvent = OnboardingSended(
                selectSubject: sub, selectTopis: topic, competence: competence);
            emit(sendEvent);
            emit(OnboardingSending());
          } else {
            emit(OnboardingSendFailure());
          }
        }
      },
    );
    on<CompetenceAdd>((event, emit) {
      final currentState = state;
      if (currentState is OnboardingReady) {
        final markedCompetence = currentState.competence
            .where((element) => element.id == event.id)
            .first;
        final toAdd = markedCompetence.copyWith(checked: true);
        final rest =
            currentState.competence.where((element) => element.id != event.id);
        emit(
          OnboardingReady(
            topics: currentState.topics,
            subject: currentState.subject,
            competence: {toAdd, ...rest},
          ),
        );
      } else {
        stateError('OnboardingSubjectRemove');
      }
    });
    on<CompetenceRemove>((event, emit) {
      final currentState = state;
      if (currentState is OnboardingReady) {
        final markedCompetence = currentState.competence
            .where((element) => element.id == event.id)
            .first;
        final toRemove = markedCompetence.copyWith(checked: false);
        final rest = currentState.competence
            .where((element) => element.id != event.id)
            .toSet();
        emit(
          OnboardingReady(
              competence: {toRemove, ...rest},
              topics: currentState.topics,
              subject: currentState.subject),
        );
      } else {
        stateError('OnboardingSubjectRemove');
      }
    });
  }

  void stateError(String event) {
    onError(
        BlocError(
            message:
                'State Error $event is not in the desired State current State is ${state.runtimeType}',
            expose: false),
        StackTrace.current);
  }
}
