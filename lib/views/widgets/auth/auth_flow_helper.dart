import 'package:flutter/material.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../core/utils/app_validators.dart'; 
import '../common/app_dialog.dart';

class AuthFlowHelper {
  
  // --- LOGIN ---
  static Future<void> login(
    BuildContext context, {
    required AuthViewModel viewModel,
    required String email,
    required String password,
  }) async {
    FocusScope.of(context).unfocus(); 
    
    // 1. Validação (Usando o Utils)
    final emailError = AppValidators.validateEmail(email);
    final passError = AppValidators.validatePassword(password);

    if (emailError != null) {
      viewModel.setError(emailError);
      return;
    }
    if (passError != null) {
      viewModel.setError(passError);
      return;
    }

    // 2. Ação
    await viewModel.login(email, password);
  }

  // --- CADASTRO ---
  static Future<void> register(
    BuildContext context, {
    required AuthViewModel viewModel,
    required String email,
    required String password,
    required String name,
    required VoidCallback onSuccess, 
  }) async {
    FocusScope.of(context).unfocus();

    // 1. Validação Centralizada
    final nameError = AppValidators.validateName(name);
    final emailError = AppValidators.validateEmail(email);
    final passError = AppValidators.validatePassword(password);

    // Verifica erros na ordem de prioridade
    if (nameError != null) {
      viewModel.setError(nameError);
      return;
    }
    if (emailError != null) {
      viewModel.setError(emailError);
      return;
    }
    if (passError != null) {
      viewModel.setError(passError);
      return;
    }

    // 2. Ação
    await viewModel.register(email, password, name);

    // 3. Feedback Visual (Se o widget ainda existir na tela)
    if (!context.mounted) return;

    if (viewModel.successMessage != null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppDialog(
          type: DialogType.success,
          title: "Conta Criada!",
          description: viewModel.successMessage,
          mainButtonText: "IR PARA LOGIN",
          onMainAction: () {
            Navigator.pop(context); 
            onSuccess(); 
          },
        ),
      );
    }
  }

  // --- RECUPERAÇÃO DE SENHA ---
  static Future<void> recoverPassword(
    BuildContext context, {
    required AuthViewModel viewModel,
  }) async {
    FocusScope.of(context).unfocus();

    final recoveryEmailController = TextEditingController();
    
    // Mostra Dialog para digitar o e-mail
    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        type: DialogType.info,
        title: "Recuperar Senha",
        description: "Digite seu e-mail para receber o link:",
        mainButtonText: "ENVIAR",
        secondaryButtonText: "CANCELAR",
        onMainAction: () => Navigator.pop(context, true),
        child: TextField(
          controller: recoveryEmailController,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "exemplo@email.com",
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );

    final emailTyped = recoveryEmailController.text.trim();

    if (shouldSend != true || emailTyped.isEmpty) return;

    // Validação
    final emailError = AppValidators.validateEmail(emailTyped);
    if (emailError != null) {
      viewModel.setError(emailError);
      return;
    }

    // Ação
    await viewModel.recoverPassword(emailTyped);

    if (!context.mounted) return;

    // Feedback
    if (viewModel.successMessage != null) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          type: DialogType.success,
          title: "E-mail Enviado!",
          description: viewModel.successMessage,
          mainButtonText: "ENTENDI",
          onMainAction: () {
            viewModel.clearMessages();
            Navigator.pop(context);
          },
        ),
      );
    } else if (viewModel.errorMessage != null) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          type: DialogType.error,
          title: "Ocorreu um erro",
          description: viewModel.errorMessage,
          mainButtonText: "TENTAR NOVAMENTE",
        ),
      );
    }
  }
}