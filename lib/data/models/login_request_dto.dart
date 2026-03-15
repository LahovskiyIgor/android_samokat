class LoginRequestDto {
  final String phone;

  LoginRequestDto({required this.phone});

  Map<String, dynamic> toJson() {
    return {"phone": phone};
  }
}