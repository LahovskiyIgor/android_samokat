class UserResponseDto {
  final int id;
  final String phone;
  final String createdAt;
  final String updatedAt;
  final String status;
  final ProfileDto? profile;
  final List<ClientCardDto> clientCards;

  UserResponseDto({
    required this.id,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.profile,
    required this.clientCards,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    return UserResponseDto(
      id: json['id'] ?? 0,
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      status: json['status'] ?? '',
      profile: json['profile'] != null 
          ? ProfileDto.fromJson(json['profile']) 
          : null,
      clientCards: (json['clientCards'] as List?)
              ?.map((e) => ClientCardDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProfileDto {
  final int id;
  final int clientId;
  final String name;
  final String email;
  final String? dob;
  final double balance;
  final String balancePrint;
  final int? avatarId;
  final AvatarDto? avatar;

  ProfileDto({
    required this.id,
    required this.clientId,
    required this.name,
    required this.email,
    this.dob,
    required this.balance,
    required this.balancePrint,
    this.avatarId,
    this.avatar,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['id'] ?? 0,
      clientId: json['clientId'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'],
      balance: (json['balance'] ?? 0).toDouble(),
      balancePrint: json['balancePrint'] ?? '',
      avatarId: json['avatarId'],
      avatar: json['avatar'] != null 
          ? AvatarDto.fromJson(json['avatar']) 
          : null,
    );
  }
}

class AvatarDto {
  final int id;
  final String filename;
  final String originalName;
  final String mimetype;
  final int size;
  final String path;
  final String createdAt;
  final String updatedAt;

  AvatarDto({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.mimetype,
    required this.size,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AvatarDto.fromJson(Map<String, dynamic> json) {
    return AvatarDto(
      id: json['id'] ?? 0,
      filename: json['filename'] ?? '',
      originalName: json['originalName'] ?? '',
      mimetype: json['mimetype'] ?? '',
      size: json['size'] ?? 0,
      path: json['path'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class ClientCardDto {
  final int id;
  final int clientId;
  final int expirationMonth;
  final int expirationYear;
  final String cardHolder;
  final String cardLastNumber;
  final bool isMain;

  ClientCardDto({
    required this.id,
    required this.clientId,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cardHolder,
    required this.cardLastNumber,
    required this.isMain,
  });

  factory ClientCardDto.fromJson(Map<String, dynamic> json) {
    return ClientCardDto(
      id: json['id'] ?? 0,
      clientId: json['clientId'] ?? 0,
      expirationMonth: json['expirationMonth'] ?? 0,
      expirationYear: json['expirationYear'] ?? 0,
      cardHolder: json['cardHolder'] ?? '',
      cardLastNumber: json['cardLastNumber'] ?? '',
      isMain: json['isMain'] ?? false,
    );
  }
}
