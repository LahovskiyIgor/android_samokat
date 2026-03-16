import 'package:by_happy/domain/entities/user_auth_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecurityService {
  Future<void> saveTokens(UserAuthData data);
  Future<void> removeTokens();
  Future<String?> getRefreshToken();
  Future<String?> getAccessToken();
  
  // Методы для работы с полными номерами карт
  Future<void> saveCardFullNumber(int cardId, String fullCardNumber);
  Future<String?> getCardFullNumber(int cardId);
  Future<void> removeCardFullNumber(int cardId);
  Future<void> clearAllCardsNumbers();
  // Future<UserAuthData?> getTokens();
}