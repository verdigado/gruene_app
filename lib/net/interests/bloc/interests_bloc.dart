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

class InterestsBloc extends Bloc<InterestsEvent, InterestsState> {
  InterestsRepository interestsRepository;

  InterestsBloc(this.interestsRepository) : super(InterestsInitial()) {
    on<InterestsLoad>((event, emit) async {
      emit(InterestsLoading());
      try {
        final res = await interestsRepository.listCompetenceAndSubject();
        emit(InterestsReady(
            topics: interestsRepository.listTopic(),
            subject: res.subject,
            competence: res.competence));
      } catch (e) {
        onError(
            BlocError(message: 'Error on Fetch Data from Api', expose: true),
            StackTrace.current);
        emit(InterestsFetchFailure());
      }
    });
    on<InterestsTopicAdd>((event, emit) {
      final currentState = state;
      if (currentState is InterestsReady) {
        currentState.topics
            .where((element) => element.id == event.id)
            .first
            .checked = true;
        emit(InterestsReady(
          topics: currentState.topics,
          subject: currentState.subject,
          competence: currentState.competence,
        ));
      } else {
        stateError('InterestsTopicAdd');
      }
    });
    on<InterestsTopicRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is InterestsReady) {
          currentState.topics
              .where((element) => element.id != event.id)
              .first
              .checked = false;
          emit(InterestsReady(
            topics: currentState.topics,
            subject: currentState.subject,
            competence: currentState.competence,
          ));
        } else {
          stateError('InterestsTopicRemove');
        }
      },
    );
    on<InterestsSubjectAdd>(
      (event, emit) {
        final currentState = state;
        if (currentState is InterestsReady) {
          final markedSubject = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          final toAdd = markedSubject.copyWith(checked: true);
          final rest =
              currentState.subject.where((element) => element.id != event.id);
          emit(
            InterestsReady(
              topics: currentState.topics,
              competence: currentState.competence,
              subject: {toAdd, ...rest},
            ),
          );
        } else {
          stateError('InterestsSubjectAdd');
        }
      },
    );
    on<InterestsSubjectRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is InterestsReady) {
          final markedSubject = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          final toRemove = markedSubject.copyWith(checked: false);
          final rest = currentState.subject
              .where((element) => element.id != event.id)
              .toSet();
          emit(
            InterestsReady(
                subject: {toRemove, ...rest},
                topics: currentState.topics,
                competence: currentState.competence),
          );
        } else {
          stateError('InterestsSubjectRemove');
        }
      },
    );

    on<InterestsDone>(
      (event, emit) async {
        // ToDo: Loading State should be implemented
        //emit(InterestsSending());
        final currentState = state;
        if (currentState is InterestsReady) {
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
          final sendEvent = InterestsSending(
              selectSubject: sub, selectTopis: topic, competence: competence);
          emit(sendEvent);
          if (await interestsRepository.interestsSend(topic, sub, competence)) {
            emit(InterestsSended(navigateToNext: event.navigateToNext));
          } else {
            emit(InterestsSendFailure());
          }
        }
      },
    );
    on<CompetenceAdd>((event, emit) {
      final currentState = state;
      if (currentState is InterestsReady) {
        final markedCompetence = currentState.competence
            .where((element) => element.id == event.id)
            .first;
        final toAdd = markedCompetence.copyWith(checked: true);
        final rest =
            currentState.competence.where((element) => element.id != event.id);
        emit(
          InterestsReady(
            topics: currentState.topics,
            subject: currentState.subject,
            competence: {toAdd, ...rest},
          ),
        );
      } else {
        stateError('InterestsSubjectRemove');
      }
    });
    on<CompetenceRemove>((event, emit) {
      final currentState = state;
      if (currentState is InterestsReady) {
        final markedCompetence = currentState.competence
            .where((element) => element.id == event.id)
            .first;
        final toRemove = markedCompetence.copyWith(checked: false);
        final rest = currentState.competence
            .where((element) => element.id != event.id)
            .toSet();
        emit(
          InterestsReady(
              competence: {toRemove, ...rest},
              topics: currentState.topics,
              subject: currentState.subject),
        );
      } else {
        stateError('InterestsSubjectRemove');
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
