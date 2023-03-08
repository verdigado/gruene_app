import 'dart:typed_data';

import 'package:gruene_app/net/profile/bloc/data/profile.dart';

abstract class ProfileRepository {
  String uploadProfileImage(Uint8List img);
  Profile getProfile();
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
        profileImageUrl: image, displayName: 'Chuck Norris', initals: 'CN');
  }
}
