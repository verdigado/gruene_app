part of 'customization_bloc.dart';

abstract class CustomizationEvent {}

class CustomizationLoad extends CustomizationEvent {}

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
