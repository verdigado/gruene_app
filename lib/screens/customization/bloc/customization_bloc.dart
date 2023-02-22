import 'dart:convert';

import 'package:bloc/bloc.dart';
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
          selectTopis: [],
          selectSubject: []));
    });
    on<CustomizationTopicAdd>((event, emit) {
      final currentState = state;
      if (currentState is CustomizationReady) {
        final newSelects = [
          ...currentState.selectTopis,
          currentState.topis.where((element) => element.id == event.id).first
        ];
        emit(CustomizationReady(
            topis: currentState.topis,
            subject: currentState.subject,
            selectTopis: newSelects,
            selectSubject: currentState.selectSubject));
      }
    });
    on<CustomizationTopicRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          emit(CustomizationReady(
              topis: currentState.topis,
              subject: currentState.subject,
              selectTopis: currentState.selectTopis
                  .where((element) => element.id != event.id)
                  .toList(),
              selectSubject: currentState.selectSubject));
        }
      },
    );
    on<CustomizationSubjectAdd>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          final newSelects = [
            ...currentState.selectSubject,
            currentState.subject
                .where((element) => element.id == event.id)
                .first
          ];
          emit(CustomizationReady(
              topis: currentState.topis,
              subject: currentState.subject,
              selectTopis: currentState.selectTopis,
              selectSubject: newSelects));
        }
      },
    );
    on<CustomizationSubjectRemove>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          emit(CustomizationReady(
              subject: currentState.subject,
              topis: currentState.topis,
              selectSubject: currentState.selectSubject
                  .where((element) => element.id != event.id)
                  .toList(),
              selectTopis: currentState.selectTopis));
        }
      },
    );

    on<CustomizationDone>(
      (event, emit) {
        final currentState = state;
        if (currentState is CustomizationReady) {
          logger.i(jsonEncode({
            'selectedTopics': currentState.selectTopis,
            'selectedSubjects': currentState.selectSubject
          }));
        }

        emit(CustomizationSend());
      },
    );
  }
}
