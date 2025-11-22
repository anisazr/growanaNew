class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Nama harus diisi";
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email harus diisi";
    // simple email regex (sufficient untuk assignment)
    final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w{2,}$");
    if (!emailRegex.hasMatch(value.trim())) return "Format email tidak valid";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password harus diisi";
    if (value.length < 6) return "Password minimal 6 karakter";
    return null;
  }
}
