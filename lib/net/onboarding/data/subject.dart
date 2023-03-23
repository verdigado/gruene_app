import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Subject extends Equatable {
  final String id;
  final String name;
  final bool checked;
  const Subject({
    required this.id,
    required this.name,
    this.checked = false,
  });

  @override
  List<Object?> get props => [id, name, checked];

  Subject copyWith({
    String? id,
    String? name,
    bool? checked,
  }) {
    return Subject(
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

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      checked: map['checked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source));

  @override
  String toString() => 'Subject(id: $id, name: $name, checked: $checked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ checked.hashCode;
}
