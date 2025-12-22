import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart'; 
import '../widgets/custom_text_field.dart'; 

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Toggle State: True = Login, False = Register
  bool _isLogin = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Helper to toggle between modes
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      // Clear errors when switching
      Provider.of<AuthViewModel>(context, listen: false).errorMessage; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    // CORREÇÃO: Removida a variável 'size' que não estava sendo usada

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Full width alignment
            children: [
              // 1. LOGO AREA
              Icon(Icons.chat_bubble_outline, size: 60, color: theme.colorScheme.primary),
              const SizedBox(height: 10),
              Text(
                'ChatFlow',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),

              // 2. DYNAMIC HEADINGS
              Text(
                _isLogin ? 'Bem vindo' : 'Crie sua conta',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900, // Black/Bold
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin ? 'Entre com a sua conta' : 'Preencha seus dados',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              // 3. ERROR MESSAGE
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

              // 4. INPUTS
              // Name Input (Only shows in Register mode)
              if (!_isLogin)
                CustomTextField(
                  controller: _nameController,
                  label: 'Nome de usuário',
                  icon: Icons.person_outline,
                ),

              CustomTextField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                icon: Icons.lock_outline,
                isPassword: true, // Activates the Eye
              ),

              // 5. FORGOT PASSWORD (Only in Login)
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => authViewModel.recoverPassword(_emailController.text),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Recuperar a senha',
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // 6. MAIN ACTION BUTTON (Full Width)
              SizedBox(
                height: 56, // Taller button
                child: authViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_isLogin) {
                            authViewModel.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          } else {
                            authViewModel.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _nameController.text.trim(), // Passes the name
                            );
                          }
                        },
                        child: Text(
                          _isLogin ? 'ENTRAR' : 'CADASTRAR',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // 7. FOOTER TOGGLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin ? 'Ainda não tem conta?' : 'Já possui cadastro?',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _isLogin ? 'Cadastre-se aqui' : 'Faça Login',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}