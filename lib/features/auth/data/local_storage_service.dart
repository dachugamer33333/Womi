// Hive elegido por simplicidad, velocidad y cero boilerplate SQL.
// NOTA: Hive devuelve Map<dynamic, dynamic> que NO es subtipo de Map<String, dynamic>.
// JsonUtils.safeMap() hace la conversión recursiva necesaria.

import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/models/user_model.dart';

class LocalStorageService {
  static const String _usersBox = 'womi_users';
  static const String _sessionBox = 'womi_session';
  static const String _sessionKey = 'current_user_id';
  static const String _activitiesKey = 'activities';
  static const String _paymentMethodsKey = 'payment_methods';
  static const String _recentDestinationsKey = 'recent_destinations';

  Future<void> init({String? path}) async {
    if (path != null) {
      Hive.init(path);
    } else {
      await Hive.initFlutter();
    }
    await Hive.openBox(_usersBox);
    await Hive.openBox(_sessionBox);
  }

  // ─── Session ───

  Box get _session => Hive.box(_sessionBox);

  Future<void> saveSession(String userId) async {
    await _session.put(_sessionKey, userId);
  }

  String? getSessionUserId() {
    return _session.get(_sessionKey) as String?;
  }

  Future<void> clearSession() async {
    await _session.delete(_sessionKey);
  }

  bool hasSession() {
    return _session.containsKey(_sessionKey);
  }

  // ─── Users ───

  Box get _users => Hive.box(_usersBox);

  Future<void> saveUser(UserModel user) async {
    await _users.put(user.id, user.toJson());
  }

  UserModel? getUser(String id) {
    final data = _users.get(id);
    if (data == null) return null;
    return UserModel.fromJson(JsonUtils.safeMap(data));
  }

  UserModel? getUserByEmail(String email) {
    final users = _users.values;
    for (final data in users) {
      final map = JsonUtils.safeMap(data);
      if (map['email'] == email) {
        return UserModel.fromJson(map);
      }
    }
    return null;
  }

  bool emailExists(String email) {
    return getUserByEmail(email) != null;
  }

  Future<void> updateUser(UserModel user) async {
    await _users.put(user.id, user.toJson());
  }

  // ─── Activities ───

  List<Map<String, dynamic>> getActivities() {
    final raw = _session.get(_activitiesKey);
    if (raw == null) return [];
    return JsonUtils.safeListOfMaps(raw);
  }

  Future<void> saveActivities(List<Map<String, dynamic>> activities) async {
    await _session.put(_activitiesKey, activities);
  }

  // ─── Payment Methods ───

  List<Map<String, dynamic>> getPaymentMethods() {
    final raw = _session.get(_paymentMethodsKey);
    if (raw == null) return [];
    return JsonUtils.safeListOfMaps(raw);
  }

  Future<void> savePaymentMethods(
      List<Map<String, dynamic>> methods) async {
    await _session.put(_paymentMethodsKey, methods);
  }

  // ─── Recent Destinations ───

  List<Map<String, dynamic>> getRecentDestinations() {
    final raw = _session.get(_recentDestinationsKey);
    if (raw == null) return [];
    return JsonUtils.safeListOfMaps(raw);
  }

  Future<void> saveRecentDestinations(
      List<Map<String, dynamic>> destinations) async {
    await _session.put(_recentDestinationsKey, destinations);
  }
}
