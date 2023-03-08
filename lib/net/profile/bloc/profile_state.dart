part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileReady extends ProfileState {
  final Profile profile;
  const ProfileReady({
    required this.profile,
  });
  @override
  List<Object> get props => [profile];
}
