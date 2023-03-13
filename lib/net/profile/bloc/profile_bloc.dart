import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/net/profile/data/profile.dart';

import 'package:gruene_app/net/profile/repository/profile_repository.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository)
      : super(ProfileState(
            profile: Profile(
                profileImageUrl: Uint8List(0),
                memberProfil: const MemberProfil(email: {}, telefon: {})),
            status: ProfileStatus.initial)) {
    on<RemoveProfileImage>((event, emit) {
      final currentState = state;
      if (currentState.status == ProfileStatus.ready) {
        profileRepository.removeProfileImage();
        emit(
          ProfileState(
              status: ProfileStatus.ready,
              profile:
                  currentState.profile.copyWith(profileImageUrl: Uint8List(0))),
        );
      }
    });
    on<UploadProfileImage>((event, emit) {
      final currentState = state;
      if (currentState.status == ProfileStatus.ready) {
        profileRepository.uploadProfileImage(event.img);
        emit(
          ProfileState(
              status: ProfileStatus.ready,
              profile:
                  currentState.profile.copyWith(profileImageUrl: event.img)),
        );
      }
    });
    on<GetProfile>((event, emit) {
      final profil = profileRepository.getProfile();
      emit(ProfileState(profile: profil, status: ProfileStatus.ready));
    });
  }
}
