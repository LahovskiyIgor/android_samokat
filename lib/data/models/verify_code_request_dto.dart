class VerifyCodeRequestDto {
  final String code;
  final String token;

  VerifyCodeRequestDto({required this.code, required this.token});

  Map<String, dynamic> toJson() {
    return {"code": code, "token": token};
  }
}