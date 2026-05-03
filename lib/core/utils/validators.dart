import 'dart:core';

class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'La contraseña debe contener al menos una mayúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'La contraseña debe contener al menos un número';
    }
    return null;
  }

  static String? phoneMX(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de teléfono es obligatorio';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      return 'El teléfono debe tener 10 dígitos';
    }
    return null;
  }

  static String? matchPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != original) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
