import 'dart:typed_data';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/net/profile/data/profile.dart';

abstract class ProfileRepository {
  String uploadProfileImage(Uint8List img);
  Profile getProfile();
  void removeProfileImage();
}

class ProfileRepositoryImpl extends ProfileRepository {
  Uint8List image = Uint8List(0);
  @override
  String uploadProfileImage(Uint8List img) {
    image = img;
    return 'api/profileimage/424245412455451';
  }

  @override
  Profile getProfile() {
    return Profile(
      profileImageUrl: image,
      displayName: 'Gustav Grün',
      initals: 'GG',
      description: ' How is going, i am Gustav Grün i like green',
      memberProfil: MemberProfil(
        givenName: 'Gustav',
        surname: 'Grün',
        politicalParty: 'Bündnis 90/Die Grünen',
        division: 'Kreisverband',
        memberId: '1064536',
        memberships: const Visibility(
            Memberships(
                client: 'client',
                organization: ' LV - Bayern, KV - Neustadt/Aisch-Bad Windsheim',
                position:
                    ' Schriftführer*in (Kreisvorstand), Ortsvorsitzende*, Mitglied eines Kommunalparlaments'),
            true),
        email: Visibility(
            [
              const FavouriteValue('Gustav@gruen.de', true),
              const FavouriteValue('GrünerGustav@gruenB90.de', false),
              const FavouriteValue('gg@gruen.de', false)
            ].lock,
            true),
        telefon: Visibility(
            [
              const FavouriteValue('+49 01724516165', true),
              const FavouriteValue('+42 0115475563', false),
              const FavouriteValue('+43 01855451616', false)
            ].lock,
            true),
      ),
    );
  }

  @override
  void removeProfileImage() {
    image = Uint8List(0);
  }
}
