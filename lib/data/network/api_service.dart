import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:by_happy/data/exceptions/auth_block_exception.dart';
import 'package:by_happy/data/exceptions/auth_exception.dart';
import 'package:by_happy/data/exceptions/unauthorized_exception.dart';
import 'package:by_happy/domain/entities/scooter.dart';
import 'package:by_happy/domain/service/security_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../../domain/entities/user_profile.dart';
import '../models/scooters_response.dart';
import '../models/tariffs_response.dart';
import '../models/zones_response.dart';

class ApiService {
  static const String baseUrl = "https://sharing-api.sparkit.by/api/v1";
  static const String fileBaseUrl = "https://sharing-api.sparkit.by";

  final SecurityService _securityService;

  ApiService(this._securityService);

  Future<String?> sendPhone(String phone, String model, String systemId) async {
    final url = Uri.parse("$baseUrl/auth/client/login");

    print("SEND PHONE");
    print(" URL: $url");
    print(
      "BODY: { phone: $phone,"
      "model: $model,"
      "systemId: $systemId"
      "}",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "model": model, "systemId": systemId}),
    );

    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data["token"];
    }

    print("ERROR: sendPhone failed");
    return null;
  }

  Future<Map<String, String>?> verifyCode(String code, String token) async {
    final url = Uri.parse("$baseUrl/auth/client/verify");
    print("BODY: { code: $code, token: $token }");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code": code, "token": token}),
    );

    print("STATUS: ${response.statusCode}");
    print("VERIFY RESPONSE: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        "accessToken": data["accessToken"],
        "refreshToken": data["refreshToken"],
      };
    } else if (response.statusCode == 400) {
      final attempts = int.parse(data["message"]);
      print("400 - Wrong code. Attempts left: $attempts");
      if (attempts == 0) {
        throw AuthBlockException();
      }
      throw AuthException("Ошибка. Неверный код.", attempts);
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    print("ERROR: verifyCode failed");
    return null;
  }

  Future<Map<String, String>?> refresh() async {
    final url = Uri.parse("$baseUrl/auth/client/refresh");

    final refreshToken = await _securityService.getRefreshToken();

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $refreshToken",
      },
    );

    print("APISERVICE: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "accessToken": data["accessToken"],
        "refreshToken": data["refreshToken"],
      };
    }

    return null;
  }

  Future<UserProfile?> getProfile() async {
    final url = Uri.parse("$baseUrl/client/me");

    String? accessToken = await _securityService.getAccessToken();

    print(
      "-------------- ACCESS TOKEN (GET PROFILE): $accessToken --------------",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final profileData = data["profile"];
      print("PROFILE DATA: $profileData");
      if (profileData == null) return null;

      String? parsedDate;
      final String? dobString = profileData["dob"];

      if (dobString != null && dobString.isNotEmpty) {
        try {
          parsedDate = DateFormat(
            'dd.MM.yyyy',
          ).format(DateTime.parse(dobString));
        } catch (e) {
          print("Could not parse date from server: $dobString");
        }
      }

      final String? avatarPath = profileData["avatar"]?["path"];
      String? fullAvatarUrl;

      if (avatarPath != null) {
        final cleanPath = avatarPath.startsWith('/')
            ? avatarPath.substring(1)
            : avatarPath;
        fullAvatarUrl = "$fileBaseUrl/$cleanPath";
        print("CONSTRUCTED AVATAR URL: $fullAvatarUrl");
      }

      return UserProfile(
        name: profileData["name"] ?? "",
        birthDate: parsedDate ?? "",
        phone: data["phone"] ?? "",
        email: profileData["email"] ?? "",
        avatarId: profileData["avatarId"],
        avatarUrl: fullAvatarUrl,
      );
    }

    return null;
  }

  Future<UserProfile?> updateProfile(UserProfile profile) async {
    final url = Uri.parse("$baseUrl/client/me");

    final accessToken = await _securityService.getAccessToken();

    print("PROFILE DOB TO SEND: ${profile!.birthDate}");

    final Map<String, dynamic> body = {};

    if (profile?.email != null) body["email"] = profile?.email;
    if (profile?.name != null) body["name"] = profile?.name;
    //TODO: просмотреть отправку даты, добавить валидацию если потребуется
    if (profile!.birthDate.isNotEmpty) body["dob"] = profile?.birthDate;
    if (profile?.avatarId != null) body["avatarId"] = profile?.avatarId;

    if (body.isEmpty) {
      return null;
    }

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final profileData = data["profile"];
      if (profileData == null) return null;

      return UserProfile(
        name: profileData["name"] ?? "",
        birthDate: profileData["dob"] ?? "",
        phone: data["phone"] ?? "",
        email: profileData["email"] ?? "",
        avatarId: profileData["avatarId"],
      );
    }

    print("RESPONSE: ${response.body}");

    throw Exception("Failed to update profile: ${response.statusCode}");
  }

  Future<int?> uploadPhoto(File imageFile) async {
    final url = Uri.parse("$baseUrl/client/upload");
    String? accessToken = await _securityService.getAccessToken();

    if (accessToken == null) {
      throw Exception("Authentication token not found.");
    }

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var request = http.MultipartRequest("POST", url);

    final mimeTypeData = lookupMimeType(
      imageFile.path,
      headerBytes: [0xFF, 0xD8],
    )?.split('/');

    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageFile.path),
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
    );

    request.files.add(multipartFile);
    request.headers.addAll({"Authorization": "Bearer $accessToken"});

    print("SENDING PHOTO...");
    print("URL: $url");
    print("HEADERS: ${request.headers}");
    print("FILENAME: ${basename(imageFile.path)}");
    print(
      "CONTENT-TYPE: ${multipartFile.contentType}",
    ); // Логируем для проверки

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return data['id'];
      } else {
        throw Exception("Failed to upload photo: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR during photo upload: $e");
      rethrow; // Перебрасываем ошибку, чтобы BLoC мог ее поймать
    }
  }

  Future<ScootersResponse?> getScooters({
    required List<double> area,
    int page = 1,
    int pageSize = 500, // Запрашиваем до 500 самокатов за раз
  }) async {

    print("api fetch start, ${area.toList()}");


    // Формируем URI с query-параметрами
    final url = Uri.https('sharing-api.sparkit.by', '/api/v1/scooter/available', {
      'readAll': 'true',
      'area': area.map((coord) => coord.toString()).toList(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });



    print("url $url");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      return null;
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken", // Используем Access Token
      },
    );

    print("APISERVICE (getScooters): ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200) {
      // Используем utf8.decode для корректной обработки любых символов (например, кириллицы)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // Парсим JSON в нашу строго типизированную модель
      return ScootersResponse.fromJson(data);
    }

    print("APISERVICE (getScooters) Error: Failed with status code ${response.statusCode}");
    return null;
  }

  Future<Scooter?> getScooterById({required int id }) async {

    final url = Uri.https('sharing-api.sparkit.by', '/api/v1/scooter/$id/client');

    print("url $url");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      return null;
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("APISERVICE (getScooters): ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Scooter.fromJson(data);
    } else if (response.statusCode == 400) {

    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    print("APISERVICE (getScooters) Error: Failed with status code ${response.statusCode}");
    return null;
  }

  Future<ZonesResponse?> getZones({
    required List<double> area,
    int page = 1,
    int pageSize = 500, // Запрашиваем до 500 самокатов за раз
  }) async {

    print("api fetch start, ${area.toList()}");


    // Формируем URI с query-параметрами
    final url = Uri.https('sharing-api.sparkit.by', '/api/v1/zone/available', {
      'readAll': 'true',
      'area': area.map((coord) => coord.toString()).toList(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });



    print("url $url");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      return null;
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken", // Используем Access Token
      },
    );

    print("APISERVICE (getZones): ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200) {
      // Используем utf8.decode для корректной обработки любых символов (например, кириллицы)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // Парсим JSON в нашу строго типизированную модель
      return ZonesResponse.fromJson(data);
    }

    print("APISERVICE (getScooters) Error: Failed with status code ${response.statusCode}");
    return null;
  }

  Future<TariffsResponse?> getAvailableTariffs({required int scooterId}) async {
    final url = Uri.parse("$baseUrl/scooterplan/$scooterId/available");

    print("url $url");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      return null;
    }

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("APISERVICE (getAvailableTariffs): ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return TariffsResponse.fromJson(data);
    }

    print("APISERVICE (getAvailableTariffs) Error: Failed with status code ${response.statusCode}");
    return null;
  }

  String? _parseErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final messages = data['message'] as List?;
      if (messages != null && messages.isNotEmpty) {
        final firstError = messages.first as Map<String, dynamic>?;
        return firstError?['message'] as String?;
      }
      return data['message'] as String?;
    }
    return null;
  }

  Future<void> addPaymentCard({
    required String cardNumber,
    required int expirationMonth,
    required int expirationYear,
    required String cvv,
  }) async {
    final url = Uri.parse("$baseUrl/client/card");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    // Убираем пробелы из номера карты
    final cleanCardNumber = cardNumber.replaceAll(' ', '');

    print("ADD CARD REQUEST:");
    print("URL: $url");
    print(
      "BODY: { "
          "cardNumber: $cleanCardNumber, "
          "expirationMonth: $expirationMonth, "
          "expirationYear: $expirationYear, "
          "cvv: ***"
          "}",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "cardNumber": cleanCardNumber, // ← Отправляем чистый номер
        "expirationMonth": expirationMonth,
        "expirationYear": expirationYear,
        "cvv": cvv,
      }),
    );

    print("ADD CARD RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Неверные данные карты', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    } else if (response.statusCode == 404) {
      throw AuthException('Пользователь не найден', 0);
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }
}
