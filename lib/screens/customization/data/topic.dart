import 'dart:convert';

class Topic {
  String id;
  String name;
  String imageUrl;
  Topic({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Topic copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'imageUrl': imageUrl});

    return result;
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Topic.fromJson(String source) => Topic.fromMap(json.decode(source));

  @override
  String toString() => 'Topic(id: $id, name: $name, imageUrl: $imageUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Topic &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
