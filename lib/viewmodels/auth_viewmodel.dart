import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import '../core/utils/auth_error_mapper.dart'; 

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
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-not-verified') {
        _errorMessage = "Sua conta ainda não foi ativada. Verifique seu e-mail.";
      } else {
        _errorMessage = AuthErrorMapper.map(e is FirebaseAuthException ? e.code : e);
      }
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
      
    } catch (e) {
      _errorMessage = AuthErrorMapper.map(e is FirebaseAuthException ? e.code : e);
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
    } catch (e) {
      _errorMessage = AuthErrorMapper.map(e is FirebaseAuthException ? e.code : e);
    } finally {
      _setLoading(false);
    }
  }

  void logout() => _authService.signOut();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}