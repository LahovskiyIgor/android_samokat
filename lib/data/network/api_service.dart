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
import '../../domain/entities/payment_card.dart';
import '../../domain/entities/scooter_order.dart';
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

  Future<List<PaymentCard>> getPaymentCards() async {
    final url = Uri.parse("$baseUrl/client/me");

    String? accessToken = await _securityService.getAccessToken();

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final clientCardsJson = data["clientCards"] as List<dynamic>?;
      
      if (clientCardsJson == null || clientCardsJson.isEmpty) {
        return [];
      }

      final cards = <PaymentCard>[];
      for (final cardJson in clientCardsJson) {
        final cardId = cardJson['id'] as int;
        // Получаем полный номер карты из локального хранилища
        final fullNumber = await _securityService.getCardFullNumber(cardId);
        
        cards.add(PaymentCard(
          id: cardId,
          clientId: cardJson['clientId'] as int,
          expirationMonth: cardJson['expirationMonth'] as int,
          expirationYear: cardJson['expirationYear'] as int,
          cardHolder: cardJson['cardHolder'] as String,
          cardLastNumber: cardJson['cardLastNumber'] as String,
          isMain: cardJson['isMain'] as bool,
          fullCardNumber: fullNumber,
        ));
      }
      
      return cards;
    }

    throw Exception("Failed to get payment cards: ${response.statusCode}");
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

  Future<int> addPaymentCard({
    required String cardNumber,
    required String cardHolder,
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
          "cardHolder: $cardHolder, "
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
        "cardNumber": cleanCardNumber,
        "cardHolder": cardHolder,
        "expirationMonth": expirationMonth,
        "expirationYear": expirationYear,
        "cvv": cvv,
      }),
    );

    print("ADD CARD RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['id'] as int;
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

  Future<void> setMainPaymentCard(int cardId) async {
    final url = Uri.parse("$baseUrl/client/card/$cardId");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("SET MAIN CARD REQUEST:");
    print("URL: $url");
    print("BODY: { isMain: true }");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "isMain": true,
      }),
    );

    print("SET MAIN CARD RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при установке основной карты', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    } else if (response.statusCode == 404) {
      throw AuthException('Карта не найдена', 0);
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<void> removePaymentCard(int cardId) async {
    final url = Uri.parse("$baseUrl/client/card/$cardId");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("REMOVE CARD REQUEST:");
    print("URL: $url");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("REMOVE CARD RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return;
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при удалении карты', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    } else if (response.statusCode == 404) {
      throw AuthException('Карта не найдена', 0);
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> bookScooter({
    required int scooterId,
    required int planId,
    int? subscriptionId,
    int? cardId,
    required bool isBalance,
    required bool isInsurance,
  }) async {
    final url = Uri.parse("$baseUrl/scooterorder/booking");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("BOOK SCOOTER REQUEST:");
    print("URL: $url");
    print(
      "BODY: { "
      "scooterId: $scooterId, "
      "planId: $planId, "
      "subscriptionId: $subscriptionId, "
      "cardId: $cardId, "
      "isBalance: $isBalance, "
      "isInsurance: $isInsurance "
      "}",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "scooterId": scooterId,
        "planId": planId,
        "subscriptionId": subscriptionId,
        "cardId": cardId,
        "isBalance": isBalance,
        "isInsurance": isInsurance,
      }),
    );

    print("BOOK SCOOTER RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при бронировании самоката', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> startRide(int orderId) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/start");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("START RIDE REQUEST:");
    print("URL: $url");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("START RIDE RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при начале поездки', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> cancelRide(int orderId) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/cancel");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("CANCEL RIDE REQUEST:");
    print("URL: $url");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("CANCEL RIDE RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при отмене поездки', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> pauseRide(int orderId) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/pause");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("PAUSE RIDE REQUEST:");
    print("URL: $url");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("PAUSE RIDE RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при паузе поездки', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> resumeRide(int orderId) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/resume");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("RESUME RIDE REQUEST:");
    print("URL: $url");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("RESUME RIDE RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при возобновлении поездки', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> finishRide(int orderId) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/finish");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("FINISH RIDE REQUEST:");
    print("URL: $url");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("FINISH RIDE RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при завершении поездки', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> payRide(int orderId) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/pay");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("PAY RIDE REQUEST:");
    print("URL: $url");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("PAY RIDE RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(data);
    } else if (response.statusCode == 400) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(data);
      throw AuthException(message ?? 'Ошибка при оплате поездки', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<List<ScooterOrder>> getClientOrders() async {
    // 1. Получаем токен
    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    /*final meUrl = Uri.parse("$baseUrl/client/me");
    final meResponse = await http.get(
      meUrl,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (meResponse.statusCode != 200) {
      print("APISERVICE Error: Failed to get client info. Status: ${meResponse.statusCode}");
      throw Exception('Не удалось получить данные пользователя');
    }

    final meData = jsonDecode(utf8.decode(meResponse.bodyBytes));
    final int clientId = meData['id']; // Извлекаем id из JSON
*/
    final url = Uri.parse("$baseUrl/scooterorder/active");

    print("GET CLIENT ORDERS REQUEST:");
    print("URL: $url");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("GET CLIENT ORDERS RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Проверяем, что пришел объект и в нем есть ключ 'data'
      if (data is Map<String, dynamic> && data['data'] is List) {
        final List ordersList = data['data'];
        return ordersList.map((json) => ScooterOrder.fromJson(json)).toList();
      }

      return [];
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw Exception('Ошибка сервера: ${response.statusCode}');
  }

  Future<List<int>> uploadScooterPhotos(List<File> images) async {
    final url = Uri.parse("$baseUrl/scooterorder/upload");
    String? accessToken = await _securityService.getAccessToken();

    if (accessToken == null) {
      throw Exception("Authentication token not found.");
    }

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({"Authorization": "Bearer $accessToken"});

    for (var imageFile in images) {
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      final mimeTypeData = lookupMimeType(
        imageFile.path,
        headerBytes: [0xFF, 0xD8],
      )?.split('/');

      var multipartFile = http.MultipartFile(
        'files',
        stream,
        length,
        filename: basename(imageFile.path),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );

      request.files.add(multipartFile);
    }

    print("SENDING SCOOTER PHOTOS...");
    print("URL: $url");
    print("FILES COUNT: ${images.length}");

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        // Предполагаем, что сервер возвращает массив id загруженных файлов
        if (data is List) {
          return data.map((item) => item as int).toList();
        } else if (data is Map<String, dynamic> && data['filesId'] is List) {
          return (data['filesId'] as List).map((item) => item as int).toList();
        }
        throw Exception("Unexpected response format from server");
      } else {
        throw Exception("Failed to upload scooter photos: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR during scooter photos upload: $e");
      rethrow;
    }
  }

  Future<ScooterOrder?> updateScooterOrderData({
    required int orderId,
    Map<String, dynamic>? data,
  }) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/data");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("UPDATE SCOOTER ORDER DATA REQUEST:");
    print("URL: $url");
    print("DATA: $data");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: data != null ? jsonEncode(data) : null,
    );

    print("UPDATE SCOOTER ORDER DATA RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(responseData);
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(responseData);
      throw AuthException(message ?? 'Ошибка при обновлении данных заказа', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }

  Future<ScooterOrder?> getScooterOrderById({required int id}) async {
    final url = Uri.parse("$baseUrl/scooterorder/$id");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("GET SCOOTER ORDER BY ID REQUEST:");
    print("URL: $url");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("GET SCOOTER ORDER BY ID RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(responseData);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw Exception('Ошибка сервера: ${response.statusCode}');
  }

  Future<ScooterOrder?> payScooterOrderWithPhotos({
    required int orderId,
    required List<int> filesId,
  }) async {
    final url = Uri.parse("$baseUrl/scooterorder/$orderId/pay");

    final accessToken = await _securityService.getAccessToken();
    if (accessToken == null) {
      print("APISERVICE Error: Access token is null.");
      throw UnauthorizedException();
    }

    print("PAY SCOOTER ORDER WITH PHOTOS REQUEST:");
    print("URL: $url");
    print("FILES ID: $filesId");

    final requestBody = {"filesId": filesId};

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(requestBody),
    );

    print("PAY SCOOTER ORDER WITH PHOTOS RESPONSE:");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return ScooterOrder.fromJson(responseData);
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final message = _parseErrorMessage(responseData);
      throw AuthException(message ?? 'Ошибка при оплате заказа с фото', 0);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw AuthBlockException();
    }

    throw AuthException('Ошибка сервера: ${response.statusCode}', 0);
  }


}
