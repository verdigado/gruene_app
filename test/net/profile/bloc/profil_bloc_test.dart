import 'package:bloc_test/bloc_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/net/profile/data/profile.dart';
import 'package:gruene_app/net/profile/repository/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  var repo = ProfileRepositoryMock();
  var profile = Profile(
    memberProfil: MemberProfil(
      email: IList(const []),
      telefon: IList(const []),
    ),
  );
  group(
    'ProfileBlocTest',
    () {
      blocTest(
        'shouldReturnProfileFromRepoWhenGetProfileEventIsEmitet',
        setUp: () {
          when(() => repo.getProfile()).thenReturn(profile);
        },
        build: () => ProfileBloc(repo),
        act: (bloc) => bloc.add(const GetProfile()),
        expect: () =>
            [ProfileState(profile: profile, status: ProfileStatus.ready)],
        verify: (_) {
          verify(() => repo.getProfile()).called(1);
        },
      );

      blocTest(
        'shouldAddTelefonnumberAsFavTitleWhenMemberProfileAddValueEventIsEmitet',
        seed: () {
          return ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [const FavouriteValue('flutter@google.com', true)].lock,
                telefon: [const FavouriteValue('+4909002222', true)].lock,
              ),
            ),
            status: ProfileStatus.ready,
          );
        },
        setUp: () {
          when(() => repo.getProfile()).thenReturn(profile);
        },
        build: () => ProfileBloc(repo),
        act: (bloc) =>
            bloc.add(const MemberProfileAddValue('telefon', '01728526555')),
        expect: () => [
          ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [const FavouriteValue('flutter@google.com', true)].lock,
                telefon: [
                  const FavouriteValue('01728526555', true),
                  const FavouriteValue('+4909002222', false)
                ].lock,
              ),
            ),
            status: ProfileStatus.ready,
          )
        ],
      );

      blocTest(
        'shouldAddEmailAsFavTitleWhenMemberProfileAddValueEventIsEmitet',
        seed: () {
          return ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [const FavouriteValue('flutter@google.com', true)].lock,
                telefon: [const FavouriteValue('+4909002222', true)].lock,
              ),
            ),
            status: ProfileStatus.ready,
          );
        },
        build: () => ProfileBloc(repo),
        act: (bloc) =>
            bloc.add(const MemberProfileAddValue('email', 'me@me.de')),
        expect: () => [
          ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [
                  const FavouriteValue('me@me.de', true),
                  const FavouriteValue('flutter@google.com', false)
                ].lock,
                telefon: [const FavouriteValue('+4909002222', true)].lock,
              ),
            ),
            status: ProfileStatus.ready,
          )
        ],
      );
      blocTest(
        'shouldSetSelectedEmailAsFavTitleWhenAddFavoritProfileEventIsEmitet',
        seed: () {
          return ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [
                  const FavouriteValue('flutter@google.com', true),
                  const FavouriteValue('gruene@gruene.com', false)
                ].lock,
                telefon: [const FavouriteValue('+4909002222', true)].lock,
              ),
            ),
            status: ProfileStatus.ready,
          );
        },
        build: () => ProfileBloc(repo),
        act: (bloc) => bloc.add(const SetFavoritProfile(favEmailItemIndex: 1)),
        expect: () => [
          ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [
                  const FavouriteValue('gruene@gruene.com', true),
                  const FavouriteValue('flutter@google.com', false),
                ].lock,
                telefon: [const FavouriteValue('+4909002222', true)].lock,
              ),
            ),
            status: ProfileStatus.ready,
          )
        ],
      );
      blocTest(
        'shouldSetSelectedTelefonnumberAsFavTitleWhenAddFavoritProfileEventIsEmitet',
        seed: () {
          return ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [
                  const FavouriteValue('flutter@google.com', true),
                ].lock,
                telefon: [
                  const FavouriteValue('+4909002222', true),
                  const FavouriteValue('+495252623574', false)
                ].lock,
              ),
            ),
            status: ProfileStatus.ready,
          );
        },
        build: () => ProfileBloc(repo),
        act: (bloc) =>
            bloc.add(const SetFavoritProfile(favTelfonnumberItemIndex: 1)),
        expect: () => [
          ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [
                  const FavouriteValue('flutter@google.com', true),
                ].lock,
                telefon: [
                  const FavouriteValue('+495252623574', true),
                  const FavouriteValue('+4909002222', false),
                ].lock,
              ),
            ),
            status: ProfileStatus.ready,
          )
        ],
      );
    },
  );
}

class ProfileRepositoryMock extends Mock implements ProfileRepository {}
