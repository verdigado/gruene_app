part of 'customization_bloc.dart';

abstract class CustomizationEvent {}

class CustomizationLoad extends CustomizationEvent {}

class CustomizationDone extends CustomizationEvent {}

class CustomizationTopicAdd extends CustomizationEvent {
  String id;
  CustomizationTopicAdd({
    required this.id,
  });
}

class CustomizationTopicRemove extends CustomizationEvent {
  String id;
  CustomizationTopicRemove({
    required this.id,
  });
}

class CustomizationSubjectAdd extends CustomizationEvent {
  String id;
  CustomizationSubjectAdd({
    required this.id,
  });
}

class CustomizationSubjectRemove extends CustomizationEvent {
  String id;
  CustomizationSubjectRemove({
    required this.id,
  });
}
