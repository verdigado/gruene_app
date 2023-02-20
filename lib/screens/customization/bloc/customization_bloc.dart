import 'package:bloc/bloc.dart';
import 'package:gruene_app/data/topic.dart';
import 'package:gruene_app/screens/customization/repository/customization_repository.dart';
import 'package:meta/meta.dart';

part 'customization_event.dart';
part 'customization_state.dart';

class CustomizationBloc extends Bloc<CustomizationEvent, CustomizationState> {
  CustomizationRepository customizationRepository;

  CustomizationBloc(this.customizationRepository)
      : super(CustomizationInitial()) {
    on<CustomizationLoad>((event, emit) {
      emit(CustomizationReady(
          topis: customizationRepository.listTopic(), subject: ['Umwelt']));
    });
  }
}
