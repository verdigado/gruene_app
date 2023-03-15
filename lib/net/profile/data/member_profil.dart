import 'dart:core';
import 'dart:core';

import 'package:flutter/foundation.dart';

@immutable
class MemberProfil {
  final String givenName;
  final String surname;
  final List<FavouriteValue<String>> email;
  final List<FavouriteValue<String>> telefon;
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
    List<FavouriteValue<String>>? email,
    List<FavouriteValue<String>>? telefon,
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

class FavouriteValue<T> implements Comparable<bool> {
  final T value;
  final bool isFavourite;

  FavouriteValue(this.value, this.isFavourite);

  @override
  int compareTo(bool other) {
    return this.isFavourite == other ? 1 : -1;
  }

  FavouriteValue<T> copyWith({
    T? value,
    bool? isFavourite,
  }) {
    return FavouriteValue<T>(
      value ?? this.value,
      isFavourite ?? this.isFavourite,
    );
  }
}
