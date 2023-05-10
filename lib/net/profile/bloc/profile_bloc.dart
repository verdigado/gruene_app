import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
              memberProfil: MemberProfil(
                email: Visibility(<FavouriteValue<String>>[].lock, true),
                telefon: Visibility(<FavouriteValue<String>>[].lock, true),
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
      var newTelfon = IList([...profil.memberProfil.telefon.value]..sort(
          (a, b) => a.compareTo(b.isFavourite),
        ));
      profil.copyWith(
        memberProfil: profil.memberProfil.copyWith(
          telefon: Visibility(newTelfon, profil.memberProfil.telefon.visible),
        ),
      );
      var newEmail = IList([...profil.memberProfil.email.value]..sort(
          (a, b) => a.compareTo(b.isFavourite),
        ));
      profil.copyWith(
        memberProfil: profil.memberProfil.copyWith(
          email: Visibility(newEmail, profil.memberProfil.email.visible),
        ),
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

    on<SetFavoritProfile>((event, emit) {
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
    on<UpdateProfileValueVisibility>((event, emit) {
      final profil = state.profile;
      if (event.fieldName == 'email') {
        var newProfil = profil.copyWith(
            memberProfil: state.profile.memberProfil.copyWith(
                email: profil.memberProfil.email
                    .copyWith(visible: event.visibel)));
        emit(ProfileState(profile: newProfil, status: ProfileStatus.ready));
      }
      if (event.fieldName == 'telefon') {
        var newProfil = profil.copyWith(
            memberProfil: state.profile.memberProfil.copyWith(
                telefon: profil.memberProfil.telefon
                    .copyWith(visible: event.visibel)));
        emit(ProfileState(profile: newProfil, status: ProfileStatus.ready));
      }
    });
  }

  void profileTelefonnumberAdd(MemberProfil memberProfil,
      MemberProfileAddValue event, Emitter<ProfileState> emit) {
    final newMemberProfil = memberProfil.copyWith(
      telefon: Visibility(
          IList(
            [
              FavouriteValue(event.value, true),
              ...memberProfil.telefon.value.map(
                (e) => FavouriteValue(e.value, false),
              ),
            ],
          ),
          memberProfil.telefon.visible),
    );
    emit(
      ProfileState(
          profile: state.profile.copyWith(memberProfil: newMemberProfil),
          status: ProfileStatus.ready),
    );
  }

  void profilEmailAdd(MemberProfil memberProfil, MemberProfileAddValue event,
      Emitter<ProfileState> emit) {
    final newMemberProfil = memberProfil.copyWith(
      email: Visibility(
          IList([
            FavouriteValue(event.value, true),
            ...memberProfil.email.value.map(
              (e) => FavouriteValue(e.value, false),
            ),
          ]),
          memberProfil.email.visible),
    );
    emit(
      ProfileState(
          profile: state.profile.copyWith(memberProfil: newMemberProfil),
          status: ProfileStatus.ready),
    );
  }

  void dispatchEmail(SetFavoritProfile event, Emitter<ProfileState> emit) {
    final memberprofil = state.profile.memberProfil;
    var newFavItem = memberprofil.email.value[event.favEmailItemIndex!]
        .copyWith(isFavourite: true);
    var removedList = [...memberprofil.email.value]
      ..removeAt(event.favEmailItemIndex!);
    final newProfil = state.profile.copyWith(
      memberProfil: memberprofil.copyWith(
        email: Visibility(
            [
              newFavItem,
              ...removedList.map(
                (e) => FavouriteValue(e.value, false),
              )
            ].lock,
            memberprofil.email.visible),
      ),
    );
    emit(
      ProfileState(profile: newProfil, status: ProfileStatus.ready),
    );
  }

  void dispatchTelefonnumber(
      SetFavoritProfile event, Emitter<ProfileState> emit) {
    final memberprofil = state.profile.memberProfil;
    var newFavItem = memberprofil.telefon.value[event.favTelfonnumberItemIndex!]
        .copyWith(isFavourite: true);
    var removedNumbers = [...memberprofil.telefon.value]
      ..removeAt(event.favTelfonnumberItemIndex!);
    final newProfil = state.profile.copyWith(
      memberProfil: memberprofil.copyWith(
        telefon: Visibility(
            IList(
              [
                newFavItem,
                ...removedNumbers.map(
                  (e) => FavouriteValue(e.value, false),
                )
              ],
            ),
            memberprofil.telefon.visible),
      ),
    );
    emit(
      ProfileState(profile: newProfil, status: ProfileStatus.ready),
    );
  }
}
