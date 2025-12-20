import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../shared/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.chat, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text('ChatFlow', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              if (authViewModel.errorMessage != null)
                Text(authViewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
              CustomTextField(controller: _emailController, label: 'E-mail', icon: Icons.email),
              CustomTextField(controller: _passwordController, label: 'Senha', icon: Icons.lock, isPassword: true),
              const SizedBox(height: 24),
              authViewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => authViewModel.login(_emailController.text, _passwordController.text),
                      child: const Text('ENTRAR'),
                    ),
              TextButton(
                onPressed: () => authViewModel.register(_emailController.text, _passwordController.text),
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}