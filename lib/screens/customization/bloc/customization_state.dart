part of 'customization_bloc.dart';

abstract class CustomizationState extends Equatable {}

class CustomizationInitial extends CustomizationState {
  @override
  List<Object?> get props => [];
}

class CustomizationLoading extends CustomizationState {
  @override
  List<Object?> get props => [];
}

class CustomizationReady extends CustomizationState {
  final Set<Topic> topis;
  final Set<Subject> subject;

  CustomizationReady({
    required this.topis,
    required this.subject,
  });

  @override
  List<Object?> get props => [topis, subject];
}

class CustomizationSended extends CustomizationState {
  final List<Topic> selectTopis;
  final List<Subject> selectSubject;
  CustomizationSended({
    required this.selectTopis,
    required this.selectSubject,
  });

  @override
  List<Object?> get props => [selectSubject, selectTopis];
}

class CustomizationSendFailure extends CustomizationState {
  @override
  List<Object?> get props => [];
}

class CustomizationSending extends CustomizationState {
  @override
  List<Object?> get props => [];
}
