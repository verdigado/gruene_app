import 'package:bloc/bloc.dart';
import 'package:gruene_app/data/topic.dart';
import 'package:gruene_app/screens/customization/repository/costumization_repository.dart';
import 'package:meta/meta.dart';

part 'costumization_event.dart';
part 'costumization_state.dart';

class CostumizationBloc extends Bloc<CostumizationEvent, CostumizationState> {
  CostumizationRepository costumizationRepository;

  CostumizationBloc(this.costumizationRepository)
      : super(CostumizationInitial()) {
    on<CostumizationLoad>((event, emit) {
      emit(CostumizationReady(
          topis: costumizationRepository.listTopic(), subject: ['Umwelt']));
    });
  }
}
