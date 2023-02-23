import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/screens/customization/data/subject.dart';
import 'package:gruene_app/screens/customization/data/topic.dart';
import 'package:gruene_app/screens/customization/repository/customization_repository.dart';

part 'customization_event.dart';
part 'customization_state.dart';

class CustomizationBloc extends Bloc<CustomizationEvent, CustomizationState> {
  CustomizationRepository customizationRepository;

  CustomizationBloc(this.customizationRepository)
      : super(CustomizationInitial()) {
    on<CustomizationLoad>((event, emit) {
      emit(CustomizationReady(
        topis: customizationRepository.listTopic(),
        subject: customizationRepository.listSubject(),
      ));
    });
    on<CustomizationTopicAdd>((event, emit) {
      final currentState = state;
      if (currentState is CustomizationReady) {
        currentState.topis
            .where((element) => element.id == event.id)
            .first
            .checked = true;
        emit(CustomizationReady(
          topis: currentState.topis,
          subject: currentState.subject,
        ));
      }
    });
    on<CustomizationTopicRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          currentState.topis
              .where((element) => element.id != event.id)
              .first
              .checked = false;
          emit(CustomizationReady(
            topis: currentState.topis,
            subject: currentState.subject,
          ));
        }
      },
    );
    on<CustomizationSubjectAdd>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          final toAdd = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          toAdd.checked = true;
          emit(CustomizationReady(
              topis: currentState.topis, subject: currentState.subject));
        }
      },
    );
    on<CustomizationSubjectRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          final toRemove = currentState.subject
              .where((element) => element.id == event.id)
              .first;
          toRemove.checked = false;
          emit(CustomizationReady(
              subject: currentState.subject, topis: currentState.topis));
        }
      },
    );

    on<CustomizationDone>(
      (event, emit) {
        emit(CustomizationSending());
        final currentState = state;
        if (currentState is CustomizationReady) {
          final sub =
              currentState.subject.where((element) => element.checked).toList();
          final topic =
              currentState.topis.where((element) => element.checked).toList();
          logger.i(
              jsonEncode({'selectedTopics': topic, 'selectedSubjects': sub}));
          if (customizationRepository.customizationSend(topic, sub)) {
            emit(CustomizationSended(selectSubject: sub, selectTopis: topic));
          } else {
            emit(CustomizationSendFailure());
          }
        }
      },
    );
  }
}
