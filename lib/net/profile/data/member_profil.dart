import 'package:flutter/foundation.dart';

@immutable
class MemberProfil {
  final String givenName;
  final String surname;
  final Set<Favourite<String>> email;
  final Set<Favourite<String>> telefon;
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
    Set<Favourite<String>>? email,
    Set<Favourite<String>>? telefon,
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

class Favourite<T> {
  final T value;
  final bool isFavourite;

  Favourite(this.value, this.isFavourite);
}
