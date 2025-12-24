class AppValidators {
  // Retorna null se estiver válido, ou a mensagem de erro se falhar
  
  static String? validateEmail(String email) {
    if (email.isEmpty) return "O e-mail é obrigatório.";
    // Regex simples para e-mail
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) return "Digite um e-mail válido.";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "A senha é obrigatória.";
    if (password.length < 6) return "A senha deve ter pelo menos 6 caracteres.";
    return null;
  }

  static String? validateName(String name) {
    if (name.trim().isEmpty) return "O nome é obrigatório.";
    return null;
  }
}