import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart'; 
import '../../widgets/custom_text_field.dart';

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
    final theme = Theme.of(context); // Atalho para usar o tema

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Ícone usando a cor primária do tema (Azul 0xFF125DFF)
              Icon(Icons.chat, size: 80, color: theme.colorScheme.primary),
              
              const SizedBox(height: 16),
              
              // Texto usando a tipografia padrão do tema + cor primária
              Text(
                'ChatFlow', 
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Mensagem de erro usando a cor de erro do tema (Vermelho)
              if (authViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    authViewModel.errorMessage!, 
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                
              CustomTextField(controller: _emailController, label: 'E-mail', icon: Icons.email),
              CustomTextField(controller: _passwordController, label: 'Senha', icon: Icons.lock, isPassword: true),
              
              const SizedBox(height: 24),
              
              authViewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      // O estilo (cor, borda, padding) já vem automático do main.dart (AppTheme)
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