import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_form.dart';
import '../widgets/auth/auth_actions.dart';
import '../widgets/auth/auth_flow_helper.dart';
import '../widgets/auth/auth_error_display.dart'; 

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final isLogin = authViewModel.isLoginMode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(isLogin: isLogin),
              
              const SizedBox(height: 32),

              const AuthErrorDisplay(), 

              AuthForm(
                isLogin: isLogin,
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                onForgotPassword: () => AuthFlowHelper.recoverPassword(
                  context, 
                  viewModel: authViewModel
                ),
              ),

              const SizedBox(height: 24),

              AuthActions(
                isLogin: isLogin,
                isLoading: authViewModel.isLoading,
                onToggleAuthMode: () {
                  authViewModel.toggleAuthMode();
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                },
                onMainAction: () {
                  if (isLogin) {
                    AuthFlowHelper.login(
                      context,
                      viewModel: authViewModel,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  } else {
                    AuthFlowHelper.register(
                      context,
                      viewModel: authViewModel,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      name: nameController.text.trim(),
                      onSuccess: () => authViewModel.toggleAuthMode(), 
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