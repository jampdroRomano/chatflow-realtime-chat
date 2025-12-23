import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_form.dart';
import '../widgets/auth/auth_actions.dart';
import '../widgets/auth/auth_flow_helper.dart'; // <--- Importe o novo Helper

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    Provider.of<AuthViewModel>(context, listen: false).clearMessages();
    setState(() {
      _isLogin = !_isLogin;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
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

              // Erro Inline 
              if (authViewModel.errorMessage != null && authViewModel.successMessage == null)
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
                onForgotPassword: () => AuthFlowHelper.recoverPassword(
                  context, 
                  viewModel: authViewModel
                ),
              ),

              const SizedBox(height: 24),

              AuthActions(
                isLogin: _isLogin,
                isLoading: authViewModel.isLoading,
                onToggleAuthMode: _toggleAuthMode,
                onMainAction: () {
                  if (_isLogin) {
                    AuthFlowHelper.login(
                      context,
                      viewModel: authViewModel,
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  } else {
                    AuthFlowHelper.register(
                      context,
                      viewModel: authViewModel,
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      name: _nameController.text.trim(),
                      onSuccess: _toggleAuthMode, 
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