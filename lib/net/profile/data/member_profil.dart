import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

@immutable
class Visibility<T> {
  final T value;
  final bool visible;
  const Visibility(this.value, this.visible);

  Visibility<T> copyWith({
    T? value,
    bool? visible,
  }) {
    return Visibility<T>(
      value ?? this.value,
      visible ?? this.visible,
    );
  }
}

@immutable
class MemberProfil extends Equatable {
  final String givenName;
  final String surname;
  final Visibility<IList<FavouriteValue<String>>> email;
  final Visibility<IList<FavouriteValue<String>>> telefon;
  final String politicalParty;
  final String division;
  final String memberId;
  final Visibility<Memberships> memberships;

  const MemberProfil({
    this.givenName = '',
    this.surname = '',
    required this.email,
    required this.telefon,
    this.politicalParty = '',
    this.division = '',
    this.memberId = '',
    this.memberships = const Visibility(Memberships(), true),
  });

  @override
  List<Object?> get props => [
        givenName,
        surname,
        email,
        telefon,
        politicalParty,
        division,
        memberships
      ];

  MemberProfil copyWith({
    String? givenName,
    String? surname,
    Visibility<IList<FavouriteValue<String>>>? email,
    Visibility<IList<FavouriteValue<String>>>? telefon,
    String? politicalParty,
    String? division,
    String? memberId,
    Visibility<Memberships>? memberships,
  }) {
    return MemberProfil(
      givenName: givenName ?? this.givenName,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      telefon: telefon ?? this.telefon,
      politicalParty: politicalParty ?? this.politicalParty,
      division: division ?? this.division,
      memberId: memberId ?? this.memberId,
      memberships: memberships ?? this.memberships,
    );
  }
}

class Memberships {
  final String organization;
  final String position;
  final String client;

  const Memberships(
      {this.organization = '', this.position = '', this.client = ''});

  Memberships copyWith({
    String? organization,
    String? position,
    String? client,
  }) {
    return Memberships(
      organization: organization ?? this.organization,
      position: position ?? this.position,
      client: client ?? this.client,
    );
  }
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
