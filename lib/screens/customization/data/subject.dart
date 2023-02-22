import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

class Subject extends ISuspensionBean {
  String id;
  String name;
  Subject({
    required this.id,
    required this.name,
  });

  @override
  String getSuspensionTag() {
    if (name.isEmpty) return '#';
    return name.characters.first.toUpperCase();
  }

  Subject copyWith({
    String? id,
    String? name,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});

    return result;
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source));

  @override
  String toString() => 'Subject(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subject && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
