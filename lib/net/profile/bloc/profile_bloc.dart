import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/profile/bloc/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<UploadProfileImage>((event, emit) {
      if (state is ProfileReady) {
        profileRepository.uploadProfileImage(event.img);
      }
    });
  }
}
