import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'member_profil.dart';

@immutable
class Profile extends Equatable {
  // TODO: This should be replaced in Future with a Url to the actual Image
  final Uint8List? profileImageUrl;
  final String displayName;
  final String initals;
  final String description;
  final MemberProfil memberProfil;
  const Profile({
    this.profileImageUrl,
    this.displayName = '',
    this.initals = '',
    this.description = '',
    required this.memberProfil,
  });

  Profile copyWith({
    Uint8List? profileImageUrl,
    String? displayName,
    String? initals,
    String? description,
    MemberProfil? memberProfil,
  }) {
    return Profile(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      displayName: displayName ?? this.displayName,
      initals: initals ?? this.initals,
      description: description ?? this.description,
      memberProfil: memberProfil ?? this.memberProfil,
    );
  }

  @override
  List<Object?> get props =>
      [profileImageUrl, displayName, initals, description, memberProfil];
}
