import 'package:flutter/material.dart';
import '../custom_text_field.dart'; 

class AuthForm extends StatelessWidget {
  final bool isLogin;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onForgotPassword;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (!isLogin)
          CustomTextField(
            controller: nameController,
            label: 'Nome de usuário',
            icon: Icons.person_outline,
          ),

        CustomTextField(
          controller: emailController,
          label: 'E-mail',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        CustomTextField(
          controller: passwordController,
          label: 'Senha',
          icon: Icons.lock_outline,
          isPassword: true,
        ),

        if (isLogin)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Recuperar a senha',
                style: TextStyle(
                  color: theme.colorScheme.primary, 
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
      ],
    );
  }
}