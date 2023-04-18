import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

@immutable
class MemberProfil extends Equatable {
  final String givenName;
  final String surname;
  final IList<FavouriteValue<String>> email;
  final IList<FavouriteValue<String>> telefon;
  final String politicalParty;
  final String division;
  final String memberId;

  const MemberProfil({
    this.givenName = '',
    this.surname = '',
    required this.email,
    required this.telefon,
    this.politicalParty = '',
    this.division = '',
    this.memberId = '',
  });

  MemberProfil copyWith({
    String? givenName,
    String? surname,
    IList<FavouriteValue<String>>? email,
    IList<FavouriteValue<String>>? telefon,
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

  @override
  List<Object?> get props =>
      [givenName, surname, email, telefon, politicalParty, division];
}

class FavouriteValue<T> extends Equatable implements Comparable<bool> {
  final T value;
  final bool isFavourite;

  const FavouriteValue(this.value, this.isFavourite);

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

  @override
  List<Object?> get props => [value, isFavourite];
}
