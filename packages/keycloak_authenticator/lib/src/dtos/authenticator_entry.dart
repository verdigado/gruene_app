class AuthenticatorEntry {
  final String id;
  final String? label;

  AuthenticatorEntry({required this.id, this.label});

  factory AuthenticatorEntry.fromJson(Map<String, dynamic> json) {
    return AuthenticatorEntry(
      id: json['id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}
