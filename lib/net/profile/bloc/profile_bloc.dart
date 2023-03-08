import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/profile/bloc/data/profile.dart';
import 'package:gruene_app/net/profile/bloc/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<UploadProfileImage>((event, emit) {
      final currentState = state;
      if (currentState is ProfileReady) {
        emit(ProfileReady(profile: currentState.profile));
      }
      if (currentState is ProfileReady) {
        profileRepository.uploadProfileImage(event.img);
        emit(ProfileReady(
            profile: Profile(
                profileImageUrl: event.img,
                initals: currentState.profile.initals,
                displayName: currentState.profile.displayName)));
      }
    });
    on<GetProfile>((event, emit) {
      final profil = profileRepository.getProfile();
      emit(ProfileReady(profile: profil));
    });
  }
}
