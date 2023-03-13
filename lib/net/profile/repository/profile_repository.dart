import 'dart:typed_data';
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
        email: {
          Favourite('gruenerGustav@gruene.de', true),
          Favourite('gustavGruen@gruene.de', false),
        },
        telefon: {
          Favourite('+491728463554123', false),
          Favourite('+491716546335', true)
        },
      ),
    );
  }

  @override
  void removeProfileImage() {
    image = Uint8List(0);
  }
}
