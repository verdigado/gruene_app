import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/logger.dart';
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
        topis: onboardingRepository.listTopic(),
        subject: onboardingRepository.listSubject(),
      ));
    });
    on<OnboardingTopicAdd>((event, emit) {
      final currentState = state;
      if (currentState is OnboardingReady) {
        currentState.topis
            .where((element) => element.id == event.id)
            .first
            .checked = true;
        emit(OnboardingReady(
          topis: currentState.topis,
          subject: currentState.subject,
        ));
      }
    });
    on<OnboardingTopicRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is OnboardingReady) {
          currentState.topis
              .where((element) => element.id != event.id)
              .first
              .checked = false;
          emit(OnboardingReady(
            topis: currentState.topis,
            subject: currentState.subject,
          ));
        }
      },
    );
    on<OnboardingSubjectAdd>(
      (event, emit) {
        final currentState = state;
        if (currentState is OnboardingReady) {
          final toAdd = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          toAdd.checked = true;
          emit(OnboardingReady(
              topis: currentState.topis, subject: currentState.subject));
        }
      },
    );
    on<OnboardingSubjectRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is OnboardingReady) {
          final toRemove = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          toRemove.checked = false;
          emit(OnboardingReady(
              subject: currentState.subject, topis: currentState.topis));
        }
      },
    );

    on<OnboardingDone>(
      (event, emit) {
        emit(OnboardingSending());
        final currentState = state;
        if (currentState is OnboardingReady) {
          final sub =
              currentState.subject.where((element) => element.checked).toList();
          final topic =
              currentState.topis.where((element) => element.checked).toList();
          logger.i(
              jsonEncode({'selectedTopics': topic, 'selectedSubjects': sub}));
          if (onboardingRepository.onboardingSend(topic, sub)) {
            emit(OnboardingSended(selectSubject: sub, selectTopis: topic));
          } else {
            emit(OnboardingSendFailure());
          }
        }
      },
    );
  }
}
