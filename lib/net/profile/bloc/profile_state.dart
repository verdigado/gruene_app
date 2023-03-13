part of 'profile_bloc.dart';

enum ProfileStatus { initial, ready }

class ProfileState extends Equatable {
  const ProfileState({required this.profile, required this.status});
  final ProfileStatus status;
  final Profile profile;

  @override
  List<Object> get props => [profile];
}
