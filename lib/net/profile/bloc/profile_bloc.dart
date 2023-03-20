import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/logger.dart';
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
              memberProfil: const MemberProfil(
                email: [],
                telefon: [],
              ),
            ),
            status: ProfileStatus.initial)) {
    on<RemoveProfileImage>((event, emit) {
      final currentState = state;
      if (currentState.status == ProfileStatus.ready) {
        // To-Do: Catch Errors of Api
        try {
          profileRepository.removeProfileImage();
        } on Exception catch (ex) {
          logger.i('Exception on RemoveProfileImage', [ex]);
          return emit(
            ProfileState(
                status: ProfileStatus.profileImageRemoveError,
                profile: currentState.profile),
          );
        }
        emit(
          ProfileState(
            status: ProfileStatus.ready,
            profile: currentState.profile.copyWith(
              profileImageUrl: Uint8List(0),
            ),
          ),
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
            profile: currentState.profile.copyWith(profileImageUrl: event.img),
          ),
        );
      }
    });
    on<GetProfile>((event, emit) {
      final profil = profileRepository.getProfile();
      profil.memberProfil.telefon.sort(
        (a, b) => a.compareTo(b.isFavourite),
      );
      emit(
        ProfileState(profile: profil, status: ProfileStatus.ready),
      );
    });

    on<MemberProfileAddValue>((event, emit) {
      final memberProfil = state.profile.memberProfil;
      if (event.fieldName == 'telefon') {
        profileTelefonnumberAdd(memberProfil, event, emit);
      }
      if (event.fieldName == 'email') {
        profilEmailAdd(memberProfil, event, emit);
      }
    });
    on<DispatchProfile>((event, emit) {
      if (event.favTelfonnumberItemIndex != null) {
        dispatchTelefonnumber(event, emit);
      } else if (event.favEmailItemIndex != null) {
        dispatchEmail(event, emit);
      } else {
        emit(
          ProfileState(profile: state.profile, status: ProfileStatus.ready),
        );
      }
    });
  }

  void profileTelefonnumberAdd(MemberProfil memberProfil,
      MemberProfileAddValue event, Emitter<ProfileState> emit) {
    final newMemberProfil = memberProfil.copyWith(telefon: [
      FavouriteValue(event.value, true),
      ...memberProfil.telefon.map(
        (e) => FavouriteValue(e.value, false),
      ),
    ]);
    emit(
      ProfileState(
          profile: state.profile.copyWith(memberProfil: newMemberProfil),
          status: ProfileStatus.ready),
    );
  }

  void profilEmailAdd(MemberProfil memberProfil, MemberProfileAddValue event,
      Emitter<ProfileState> emit) {
    final newMemberProfil = memberProfil.copyWith(email: [
      FavouriteValue(event.value, true),
      ...memberProfil.email.map(
        (e) => FavouriteValue(e.value, false),
      ),
    ]);
    emit(
      ProfileState(
          profile: state.profile.copyWith(memberProfil: newMemberProfil),
          status: ProfileStatus.ready),
    );
  }

  void dispatchEmail(DispatchProfile event, Emitter<ProfileState> emit) {
    final memberprofil = state.profile.memberProfil;
    var newFavItem = memberprofil.email[event.favEmailItemIndex!]
        .copyWith(isFavourite: true);
    memberprofil.email.removeAt(event.favEmailItemIndex!);
    final newProfil = state.profile.copyWith(
      memberProfil: memberprofil.copyWith(
        email: [
          newFavItem,
          ...memberprofil.email.map(
            (e) => FavouriteValue(e.value, false),
          )
        ],
      ),
    );
    emit(
      ProfileState(profile: newProfil, status: ProfileStatus.ready),
    );
  }

  void dispatchTelefonnumber(
      DispatchProfile event, Emitter<ProfileState> emit) {
    final memberprofil = state.profile.memberProfil;
    var newFavItem = memberprofil.telefon[event.favTelfonnumberItemIndex!]
        .copyWith(isFavourite: true);
    memberprofil.telefon.removeAt(event.favTelfonnumberItemIndex!);
    final newProfil = state.profile.copyWith(
      memberProfil: memberprofil.copyWith(
        telefon: [
          newFavItem,
          ...memberprofil.telefon.map(
            (e) => FavouriteValue(e.value, false),
          )
        ],
      ),
    );
    emit(
      ProfileState(profile: newProfil, status: ProfileStatus.ready),
    );
  }
}
