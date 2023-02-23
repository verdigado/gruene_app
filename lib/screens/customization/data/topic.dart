import 'dart:convert';

import 'package:gruene_app/screens/customization/data/subject.dart';

class Topic {
  String id;
  String name;
  String imageUrl;
  bool checked;
  Topic({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.checked = false,
  });

  Topic copyWith({
    String? id,
    String? name,
    String? imageUrl,
    bool? checked,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'checked': checked});

    return result;
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      checked: map['checked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Topic.fromJson(String source) => Topic.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Topic(id: $id, name: $name, imageUrl: $imageUrl, checked: $checked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Topic && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode ^ checked.hashCode;
  }
}
