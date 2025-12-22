import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Login Logic
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signIn(email, password);
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
    } catch (e) {
      _errorMessage = "Ocorreu um erro inesperado.";
    } finally {
      _setLoading(false);
    }
  }

  // Register Logic (UPDATED)
  Future<void> register(String email, String password, String name) async {
    _setLoading(true);
    try {
      if (name.trim().isEmpty) throw Exception("O nome é obrigatório.");
      
      await _authService.signUp(email, password, name);
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapFirebaseError(e.code);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _setLoading(false);
    }
  }

  // Recover Password Logic (New)
  Future<void> recoverPassword(String email) async {
    if (email.isEmpty) {
      _errorMessage = "Digite seu e-mail para recuperar a senha.";
      notifyListeners();
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _errorMessage = "E-mail de recuperação enviado!";
    } catch (e) {
      _errorMessage = "Erro ao enviar e-mail.";
    }
    notifyListeners();
  }

  void logout() {
    _authService.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found': return 'Usuário não encontrado.';
      case 'wrong-password': return 'Senha incorreta.';
      case 'email-already-in-use': return 'Este e-mail já está cadastrado.';
      case 'weak-password': return 'A senha é muito fraca.';
      case 'invalid-email': return 'E-mail inválido.';
      default: return 'Erro de autenticação: $code';
    }
  }
}