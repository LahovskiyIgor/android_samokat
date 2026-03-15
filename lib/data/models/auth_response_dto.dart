class AuthResponseDto {
  final String accessToken;
  final String refreshToken;

  AuthResponseDto({required this.accessToken, required this.refreshToken});

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
    );
  }
}