import 'dart:typed_data';

abstract class ProfileRepository {
  void uploadProfileImage(Uint8List img);
}

class ProfileRepositoryImpl extends ProfileRepository {
  @override
  void uploadProfileImage(Uint8List img) {
    print('Send Img');
  }
}
