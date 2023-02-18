part of 'costumization_bloc.dart';

abstract class CostumizationState {}

class CostumizationInitial extends CostumizationState {}

class CostumizationLoading extends CostumizationState {}

class CostumizationReady extends CostumizationState {
  List<Topic> topis = [];
  List<String> subject = [];
  CostumizationReady({
    required this.topis,
    required this.subject,
  });
}

class CostumizationSend extends CostumizationState {}
