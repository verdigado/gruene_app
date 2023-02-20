part of 'customization_bloc.dart';

abstract class CustomizationState {}

class CustomizationInitial extends CustomizationState {}

class CustomizationLoading extends CustomizationState {}

class CustomizationReady extends CustomizationState {
  List<Topic> topis = [];
  List<String> subject = [];
  CustomizationReady({
    required this.topis,
    required this.subject,
  });
}

class CustomizationSend extends CustomizationState {}
