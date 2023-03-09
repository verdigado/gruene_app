import 'dart:typed_data';

class Profile {
  // TODO: This should be replaced in Future with a Url to the actual Image
  Uint8List? profileImageUrl;
  String displayName;
  String initals;
  String description;
  Profile(
      {this.profileImageUrl,
      this.displayName = '',
      this.initals = '',
      this.description = ''});
}
