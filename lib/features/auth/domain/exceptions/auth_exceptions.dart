class EmailAlreadyExistsException implements Exception {
  final String message;
  const EmailAlreadyExistsException([this.message = 'Este correo ya está registrado']);

  @override
  String toString() => message;
}

class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException(
      [this.message = 'Correo o contraseña incorrectos']);

  @override
  String toString() => message;
}

class UserNotFoundException implements Exception {
  final String message;
  const UserNotFoundException([this.message = 'Usuario no encontrado']);

  @override
  String toString() => message;
}
