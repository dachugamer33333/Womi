import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../domain/exceptions/auth_exceptions.dart';
import '../domain/models/user_model.dart';
import 'local_storage_service.dart';

String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}

String _generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

class AuthRepository {
  final LocalStorageService _storage;

  AuthRepository(this._storage);

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (_storage.emailExists(email.trim().toLowerCase())) {
      throw const EmailAlreadyExistsException();
    }

    final user = UserModel(
      id: _generateId(),
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.replaceAll(RegExp(r'\D'), ''),
      passwordHash: _hashPassword(password),
      isVerified: false,
      createdAt: DateTime.now(),
      walletBalance: 0.0,
      couponsCount: 0,
      cardsCount: 0,
    );

    await _storage.saveUser(user);
    await _storage.saveSession(user.id);
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final user = _storage.getUserByEmail(email.trim().toLowerCase());
    if (user == null) {
      throw const InvalidCredentialsException();
    }

    final inputHash = _hashPassword(password);
    if (inputHash != user.passwordHash) {
      throw const InvalidCredentialsException();
    }

    await _storage.saveSession(user.id);
    return user;
  }

  Future<void> logout() async {
    await _storage.clearSession();
  }

  Future<UserModel?> getCurrentUser() async {
    final id = _storage.getSessionUserId();
    if (id == null) return null;
    return _storage.getUser(id);
  }

  Future<bool> isLoggedIn() async {
    return _storage.hasSession();
  }

  Future<void> updateUser(UserModel user) async {
    await _storage.updateUser(user);
  }

  // ─── Activities ───

  List<Map<String, dynamic>> getActivities() {
    return _storage.getActivities();
  }

  Future<void> saveActivities(List<Map<String, dynamic>> activities) async {
    await _storage.saveActivities(activities);
  }

  // ─── Payment Methods ───

  List<Map<String, dynamic>> getPaymentMethods() {
    return _storage.getPaymentMethods();
  }

  Future<void> savePaymentMethods(
      List<Map<String, dynamic>> methods) async {
    await _storage.savePaymentMethods(methods);
  }

  // ─── Recent Destinations ───

  List<Map<String, dynamic>> getRecentDestinations() {
    return _storage.getRecentDestinations();
  }

  Future<void> saveRecentDestinations(
      List<Map<String, dynamic>> destinations) async {
    await _storage.saveRecentDestinations(destinations);
  }
}
