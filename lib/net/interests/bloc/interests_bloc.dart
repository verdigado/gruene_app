import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/exception/bloc_exception.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/net/interests/data/competence.dart';
import 'package:gruene_app/net/interests/data/subject.dart';
import 'package:gruene_app/net/interests/data/topic.dart';
import 'package:gruene_app/net/interests/repository/interests_repository.dart';

part 'interests_event.dart';
part 'interests_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingRepository onboardingRepository;

  OnboardingBloc(this.onboardingRepository) : super(OnboardingInitial()) {
    on<OnboardingLoad>((event, emit) async {
      emit(OnboardingLoading());
      try {
        final res = await onboardingRepository.listCompetenceAndSubject();
        emit(OnboardingReady(
            topics: onboardingRepository.listTopic(),
            subject: res.subject,
            competence: res.competence));
      } catch (e) {
        onError(
            BlocError(message: 'Error on Fetch Data from Api', expose: true),
            StackTrace.current);
        emit(OnboardingFetchFailure());
      }
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
      (event, emit) async {
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
          final sendEvent = OnboardingSending(
              selectSubject: sub, selectTopis: topic, competence: competence);
          emit(sendEvent);
          if (await onboardingRepository.onboardingSend(
              topic, sub, competence)) {
            emit(OnboardingSended(navigateToNext: event.navigateToNext));
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