part of 'customization_bloc.dart';

abstract class CustomizationState {}

class CustomizationInitial extends CustomizationState {}

class CustomizationLoading extends CustomizationState {}

class CustomizationReady extends CustomizationState {
  List<Topic> topis = [];
  List<Subject> subject = [];
  List<Topic> selectTopis = [];
  List<Subject> selectSubject = [];
  CustomizationReady({
    required this.topis,
    required this.subject,
    required this.selectTopis,
    required this.selectSubject,
  });
}

class CustomizationSend extends CustomizationState {}
