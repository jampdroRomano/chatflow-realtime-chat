import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    _setLoading(true);
    clearMessages();
    try {
      await _authService.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-not-verified') {
        _errorMessage = "Sua conta ainda não foi ativada. Verifique seu e-mail.";
      } else {
        _errorMessage = _mapFirebaseError(e.code);
      }
    } catch (e) {
      _errorMessage = _mapFirebaseError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // CADASTRO
  Future<void> register(String email, String password, String name) async {
    _setLoading(true);
    clearMessages();
    try {
      if (name.trim().isEmpty) throw Exception("O nome é obrigatório.");
      
      await _authService.signUp(email, password, name);
      
      _successMessage = "Cadastro realizado! Enviamos um e-mail de ativação para $email.";
      
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
    } catch (e) {
      String code = e.toString().contains("channel-error") ? "channel-error" : e.toString();
      _errorMessage = _mapFirebaseError(code);
    } finally {
      _setLoading(false);
    }
  }

  // RECUPERAR SENHA
  Future<void> recoverPassword(String email) async {
    clearMessages();
    if (email.isEmpty) {
      _errorMessage = "Digite seu e-mail para recuperar a senha.";
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _successMessage = "E-mail de recuperação enviado! Verifique sua caixa de entrada.";
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _authService.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapFirebaseError(String code) {
    if (code.contains('channel-error')) return 'Preencha todos os campos.';
    if (code.contains('Exception: ')) code = code.replaceAll('Exception: ', '');

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