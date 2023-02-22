import 'package:gruene_app/screens/customization/data/topic.dart';

abstract class CustomizationRepository {
  List<Topic> listTopic();
}

class CustomizationRepositoryImpl extends CustomizationRepository {
  @override
  List<Topic> listTopic() {
    return [
      Topic(
          id: '1',
          name: 'Umwelt',
          imageUrl:
              'https://www.zg.ch/behoerden/baudirektion/arv/natur-landschaft/landschaft_block_1/@@images/2fd8ba74-45ce-4b97-a60e-5c4ea13d2390.jpeg'),
      Topic(
          id: '2',
          name: 'Tiere',
          imageUrl:
              'https://img.welt.de/img/wissenschaft/mobile241775617/0262505187-ci102l-w1024/A-beautiful-smooth-haired-red-cat-lies-on-the-sofa-and-in-a-relax.jpg'),
      Topic(
          id: '3',
          name: 'News',
          imageUrl:
              'https://media.istockphoto.com/id/1301656823/photo/daily-papers-with-news-on-the-computer.jpg?b=1&s=170667a&w=0&k=20&c=Y0krx8wEAxLd7-ObYRSzLIA8XaSpA7bkuiCYbjR-ZTA='),
      Topic(
          id: '4',
          name: 'Aktionen',
          imageUrl:
              'https://media.istockphoto.com/id/1040595704/fr/photo/amis-au-festival-de-musique.jpg?s=612x612&w=0&k=20&c=tZpZYx18A8AfqMwKGEhg_WWBww1ZNsTHMChBGWvbbus='),
      Topic(
        id: '5',
        name: 'Politik',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/3/3f/2020-02-13_Deutscher_Bundestag_IMG_3438_by_Stepro.jpg',
      ),
    ];
  }
}
