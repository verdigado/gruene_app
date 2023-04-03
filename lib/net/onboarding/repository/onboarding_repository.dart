import 'package:gruene_api_client/gruene_api_client.dart';
import 'package:gruene_app/constants/app_const.dart';
import 'package:gruene_app/net/client.dart';
import 'package:gruene_app/net/onboarding/data/competence.dart';
import 'package:gruene_app/net/onboarding/data/subject.dart';
import 'package:gruene_app/net/onboarding/data/topic.dart';

abstract class OnboardingRepository {
  Set<Topic> listTopic();

  Future<OnboardingListResult> listCompetenceAndSubject();
  Future<bool> onboardingSend(
      List<Topic> topics, List<Subject> subjects, List<Competence> competence);
}

class OnboardingRepositoryImpl extends OnboardingRepository {
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
      const Subject(id: '534sfd51', name: 'Asylpolitik'),
      const Subject(id: '94sdf3', name: 'Außenpolitik'),
      const Subject(id: '25sdf3', name: 'Bauen'),
      const Subject(id: '332fsd3', name: 'Europa'),
      const Subject(id: '853sfd4', name: 'Zeitpolitik'),
      const Subject(id: '45sdf34', name: 'Friedenspolitik'),
      const Subject(id: '53fdssfd452', name: 'Gesundheit'),
      const Subject(id: '62sfd5', name: 'Globalisierung'),
      const Subject(id: '7sdfsfe53', name: 'Handelsabkommen'),
      const Subject(id: '853fdsf4', name: 'Handelspolitik'),
      const Subject(id: '85fsdf34', name: 'Hamburgpolitik'),
      const Subject(id: '853sdfsfsf4', name: 'Hamsterpolitik'),
      const Subject(id: '853sdfsdfs4', name: 'Hundepolitik'),
      const Subject(id: '83sfsdffd54', name: 'Hauspolitik'),
      const Subject(id: '85sdfs34', name: 'Heimpolitik'),
      const Subject(id: '8sdsf534', name: 'Himmelpolitik'),
      const Subject(id: '85sfsd34', name: 'Handpolitik'),
      const Subject(id: '85sdsdffs34', name: 'Hemdpolitik'),
      const Subject(id: '2344dsfffw', name: 'Hallopolitik'),
      const Subject(id: '53sdfds48', name: 'Haarpolitik'),
      const Subject(id: '83sdf425', name: 'Halspolitik'),
      const Subject(id: '45dsdfssf38', name: 'Handelspolitik'),
      const Subject(id: '53sdf49', name: 'Innenpolitik'),
    };
  }

  @override
  Future<bool> onboardingSend(
      List<Topic> topics, List<Subject> subjects, List<Competence> competence) {
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  @override
  Future<OnboardingListResult> listCompetenceAndSubject() async {
    final response = await AppConst.values.api.getTagsApi().findTags();
    var competence = response.data?.items
            .where((tag) => tag.type == TagTypeEnum.skill)
            .map((tag) => Competence(id: tag.id, name: tag.tag, checked: false))
            .toSet() ??
        {};
    var subject = response.data?.items
            .where((tag) => tag.type == TagTypeEnum.interest)
            .map((tag) => Subject(id: tag.id, name: tag.tag, checked: false))
            .toSet() ??
        {};
    return OnboardingListResult(competence, subject);
  }
}

class OnboardingListResult {
  final Set<Competence> competence;
  final Set<Subject> subject;

  OnboardingListResult(this.competence, this.subject);
}
