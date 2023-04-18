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
        email: [
          const FavouriteValue('gruenerGustav@gruene.de', true),
          const FavouriteValue('gustavGruen@gruene.de', false),
        ].lock,
        telefon: [
          const FavouriteValue('01725463554', false),
          const FavouriteValue('+491716546335', false),
          const FavouriteValue('004940297234', false),
          const FavouriteValue('0049049301', true)
        ].lock,
      ),
    );
  }

  @override
  void removeProfileImage() {
    image = Uint8List(0);
  }
}
