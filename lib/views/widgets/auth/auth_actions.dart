import 'package:flutter/material.dart';

class AuthActions extends StatelessWidget {
  final bool isLogin;
  final bool isLoading;
  final VoidCallback onMainAction;
  final VoidCallback onToggleAuthMode;

  const AuthActions({
    super.key,
    required this.isLogin,
    required this.isLoading,
    required this.onMainAction,
    required this.onToggleAuthMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          width: double.infinity,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  onPressed: onMainAction,
                  child: Text(
                    isLogin ? 'ENTRAR' : 'CADASTRAR',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? 'Ainda não tem conta?' : 'Já possui cadastro?',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            TextButton(
              onPressed: onToggleAuthMode,
              child: Text(
                isLogin ? 'Cadastre-se aqui' : 'Faça Login',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}