import 'package:gruene_app/swagger_generated_code/gruene_api.swagger.dart';

class DivisionModel {
  String id;
  String levelName;

  DivisionModel({
    required this.id,
    required this.levelName,
  });

  static DivisionModel fromApi(Division division) {
    return DivisionModel(
      id: division.id,
      levelName: division.name1,
    );
  }
}
