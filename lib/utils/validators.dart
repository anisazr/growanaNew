// lib/utils/validators.dart
class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nama harus diisi";
    }
    if (value.trim().length < 3) {
      return "Nama minimal 3 karakter";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email harus diisi";
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return "Format email tidak valid";
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password harus diisi";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }
}