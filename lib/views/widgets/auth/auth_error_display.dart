import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class AuthErrorDisplay extends StatelessWidget {
  const AuthErrorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);

    if (authViewModel.errorMessage == null || authViewModel.successMessage != null) {
      return const SizedBox.shrink(); 
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
                    color: theme.colorScheme.error.withAlpha((255 * 0.1).round()),        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        authViewModel.errorMessage!,
        style: TextStyle(color: theme.colorScheme.error),
        textAlign: TextAlign.center,
      ),
    );
  }
}
