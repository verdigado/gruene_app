import 'dart:typed_data';
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
        displayName: 'Chuck Norris',
        initals: 'CN',
        description: ' How is going, I am Chuck');
  }

  @override
  void removeProfileImage() {
    image = Uint8List(0);
  }
}
