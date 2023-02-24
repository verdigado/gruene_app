import 'package:gruene_app/screens/customization/data/topic.dart';

import 'package:gruene_app/screens/customization/data/subject.dart';

abstract class CustomizationRepository {
  Set<Topic> listTopic();

  Set<Subject> listSubject();
  bool customizationSend(List<Topic> topics, List<Subject> subjects);
}

class CustomizationRepositoryImpl extends CustomizationRepository {
  @override
  Set<Topic> listTopic() {
    return {
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
    };
  }

  @override
  Set<Subject> listSubject() {
    return {
      Subject(id: '534sfd51', name: 'Asylpolitik'),
      Subject(id: '94sdf3', name: 'Außenpolitik'),
      Subject(id: '25sdf3', name: 'Bauen'),
      Subject(id: '332fsd3', name: 'Europa'),
      Subject(id: '853sfd4', name: 'Zeitpolitik'),
      Subject(id: '45sdf34', name: 'Friedenspolitik'),
      Subject(id: '53fdssfd452', name: 'Gesundheit'),
      Subject(id: '62sfd5', name: 'Globalisierung'),
      Subject(id: '7sdfsfe53', name: 'Handelsabkommen'),
      Subject(id: '853fdsf4', name: 'Handelspolitik'),
      Subject(id: '85fsdf34', name: 'Hamburgpolitik'),
      Subject(id: '853sdfsfsf4', name: 'Hamsterpolitik'),
      Subject(id: '853sdfsdfs4', name: 'Hundepolitik'),
      Subject(id: '83sfsdffd54', name: 'Hauspolitik'),
      Subject(id: '85sdfs34', name: 'Heimpolitik'),
      Subject(id: '8sdsf534', name: 'Himmelpolitik'),
      Subject(id: '85sfsd34', name: 'Handpolitik'),
      Subject(id: '85sdsdffs34', name: 'Hemdpolitik'),
      Subject(id: '2344dsfffw', name: 'Hallopolitik'),
      Subject(id: '53sdfds48', name: 'Haarpolitik'),
      Subject(id: '83sdf425', name: 'Halspolitik'),
      Subject(id: '45dsdfssf38', name: 'Handelspolitik'),
      Subject(id: '53sdf49', name: 'Innenpolitik'),
    };
  }

  @override
  bool customizationSend(List<Topic> topics, List<Subject> subjects) {
    return true;
  }
}
