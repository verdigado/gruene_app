import 'package:flutter/foundation.dart';

@immutable
class MemberProfil {
  final String givenName;
  final String surname;
  final Set<FavouriteValue<String>> email;
  final Set<FavouriteValue<String>> telefon;
  final String politicalParty;
  final String division;

  const MemberProfil({
    this.givenName = '',
    this.surname = '',
    required this.email,
    required this.telefon,
    this.politicalParty = '',
    this.division = '',
  });

  MemberProfil copyWith({
    String? givenName,
    String? surname,
    Set<FavouriteValue<String>>? email,
    Set<FavouriteValue<String>>? telefon,
    String? politicalParty,
    String? division,
  }) {
    return MemberProfil(
      givenName: givenName ?? this.givenName,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      telefon: telefon ?? this.telefon,
      politicalParty: politicalParty ?? this.politicalParty,
      division: division ?? this.division,
    );
  }
}

class FavouriteValue<T> {
  final T value;
  final bool isFavourite;

  FavouriteValue(this.value, this.isFavourite);
}
