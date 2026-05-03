import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  Future<void> checkSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _repository.getCurrentUser();
    } catch (_) {
      _currentUser = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _repository.login(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on InvalidCredentialsException {
      _errorMessage = 'Correo o contraseña incorrectos';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _repository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on EmailAlreadyExistsException {
      _errorMessage = 'Este correo ya está registrado';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await _repository.updateUser(user);
    _currentUser = user;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  AuthRepository get repository => _repository;
}
