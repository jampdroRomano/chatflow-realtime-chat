class AuthErrorMapper {
  static String map(dynamic e) {
    String code = e.toString();
    
    // Tratamentos específicos do seu projeto
    if (code.contains('channel-error')) return 'Preencha todos os campos.';
    if (code.contains('Exception: ')) code = code.replaceAll('Exception: ', '');

    // Mapeamento do Firebase
    switch (code) {
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'E-mail ou senha incorretos.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'email-already-in-use':
        return 'Este e-mail já está sendo usado.';
      case 'weak-password':
        return 'A senha é muito fraca (mínimo 6 caracteres).';
      case 'invalid-email':
        return 'O e-mail digitado é inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro: $code';
    }
  }
}