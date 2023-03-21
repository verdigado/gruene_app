import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/member_profil.dart';
import 'package:gruene_app/net/profile/data/profile.dart';
import 'package:gruene_app/net/profile/repository/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  var repo = ProfileRepositoryMock();
  var profile =
      const Profile(memberProfil: MemberProfil(email: [], telefon: []));
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
        'shouldAddTelefonnumberAsFavWhenMemberProfileAddValueEventIsEmitet',
        seed: () {
          return const ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [FavouriteValue('flutter@google.com', true)],
                telefon: [FavouriteValue('+4909002222', true)],
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
          const ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [FavouriteValue('flutter@google.com', true)],
                telefon: [
                  FavouriteValue('01728526555', true),
                  FavouriteValue('+4909002222', false)
                ],
              ),
            ),
            status: ProfileStatus.ready,
          )
        ],
      );

      blocTest(
        'shouldAddEmailAsFavWhenMemberProfileAddValueEventIsEmitet',
        seed: () {
          return const ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [FavouriteValue('flutter@google.com', true)],
                telefon: [FavouriteValue('+4909002222', true)],
              ),
            ),
            status: ProfileStatus.ready,
          );
        },
        build: () => ProfileBloc(repo),
        act: (bloc) =>
            bloc.add(const MemberProfileAddValue('email', 'me@me.de')),
        expect: () => [
          const ProfileState(
            profile: Profile(
              memberProfil: MemberProfil(
                email: [
                  FavouriteValue('me@me.de', true),
                  FavouriteValue('flutter@google.com', false)
                ],
                telefon: [FavouriteValue('+4909002222', true)],
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
