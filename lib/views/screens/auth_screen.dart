import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_form.dart';
import '../widgets/auth/auth_actions.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      Provider.of<AuthViewModel>(context, listen: false).errorMessage; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(isLogin: _isLogin),
              
              const SizedBox(height: 32),

              // Mensagem de Erro
              if (authViewModel.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    authViewModel.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              AuthForm(
                isLogin: _isLogin,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                onForgotPassword: () => authViewModel.recoverPassword(_emailController.text),
              ),

              const SizedBox(height: 24),

              AuthActions(
                isLogin: _isLogin,
                isLoading: authViewModel.isLoading,
                onToggleAuthMode: _toggleAuthMode,
                onMainAction: () {
                  if (_isLogin) {
                    authViewModel.login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  } else {
                    authViewModel.register(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _nameController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}