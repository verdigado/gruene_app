import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Competence extends Equatable {
  final String id;
  final String name;
  final bool checked;
  const Competence({
    required this.id,
    required this.name,
    required this.checked,
  });

  @override
  List<Object?> get props => [id, name, checked];

  Competence copyWith({
    String? id,
    String? name,
    bool? checked,
  }) {
    return Competence(
      id: id ?? this.id,
      name: name ?? this.name,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'checked': checked});

    return result;
  }

  factory Competence.fromMap(Map<String, dynamic> map) {
    return Competence(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      checked: map['checked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Competence.fromJson(String source) =>
      Competence.fromMap(json.decode(source));

  @override
  String toString() => 'Competence(id: $id, name: $name, checked: $checked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Competence &&
        other.id == id &&
        other.name == name &&
        other.checked == checked;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ checked.hashCode;
}
