class UserProfile {
  String name;
  String birthDate;
  String phone;
  String email;
  int? avatarId;
  String? avatarUrl;

  UserProfile({
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
    this.avatarId,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? birthDate,
    String? email,
    int? avatarId,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      phone: phone, // телефон не меняется
      email: email ?? this.email,
      avatarId: avatarId ?? this.avatarId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
