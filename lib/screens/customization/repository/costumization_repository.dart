import 'package:gruene_app/data/topic.dart';

abstract class CustomizationRepository {
  List<Topic> listTopic();
}

class CustomizationRepositoryImpl extends CustomizationRepository {
  @override
  List<Topic> listTopic() {
    return [
      Topic(
          name: 'Pandabären',
          imageUrl:
              'https://www.wwf.de/fileadmin/_processed_/c/d/csm_grosser-panda-ruhend-china-WW24373-c-naturepl-com-Andy-Rouse-WWF_b9632a8332.jpg'),
      Topic(
          name: 'Katzen',
          imageUrl:
              'https://img.welt.de/img/wissenschaft/mobile241775617/0262505187-ci102l-w1024/A-beautiful-smooth-haired-red-cat-lies-on-the-sofa-and-in-a-relax.jpg')
    ];
  }
}
