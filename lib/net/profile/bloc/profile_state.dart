part of 'profile_bloc.dart';

enum ProfileStatus { initial, ready, dispached }

class ProfileState extends Equatable {
  const ProfileState({required this.profile, required this.status});
  final ProfileStatus status;
  final Profile profile;

  @override
  List<Object> get props => [
        profile,
        profile.description,
        profile.memberProfil,
        profile.memberProfil.email,
        profile.memberProfil.telefon
      ];

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
    );
  }
}
