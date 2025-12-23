import 'package:flutter/material.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../common/app_dialog.dart';

class AuthFlowHelper {
  
  // --- LÓGICA DE LOGIN ---
  static Future<void> login(
    BuildContext context, {
    required AuthViewModel viewModel,
    required String email,
    required String password,
  }) async {
    FocusScope.of(context).unfocus();
    
    // Validação Manual Inline
    if (email.isEmpty || password.isEmpty) {
      viewModel.setError("Preencha o e-mail e a senha.");
      return;
    }

    if (!email.contains('@')) {
      viewModel.setError("Digite um e-mail válido.");
      return;
    }

    await viewModel.login(email, password);
  }

  // --- LÓGICA DE CADASTRO ---
  static Future<void> register(
    BuildContext context, {
    required AuthViewModel viewModel,
    required String email,
    required String password,
    required String name,
    required VoidCallback onSuccess, 
  }) async {
    FocusScope.of(context).unfocus();

    // Validação Manual Inline
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      viewModel.setError("Todos os campos são obrigatórios.");
      return;
    }

    if (!email.contains('@')) {
      viewModel.setError("E-mail inválido.");
      return;
    }

    if (password.length < 6) {
      viewModel.setError("A senha deve ter pelo menos 6 caracteres.");
      return;
    }

    await viewModel.register(email, password, name);

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

  // --- LÓGICA DE RECUPERAÇÃO DE SENHA ---
  static Future<void> recoverPassword(
    BuildContext context, {
    required AuthViewModel viewModel,
  }) async {
    FocusScope.of(context).unfocus();

    final recoveryEmailController = TextEditingController();
    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        type: DialogType.info,
        title: "Recuperar Senha",
        description: "Digite seu e-mail para receber o link de redefinição:",
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

    if (!emailTyped.contains('@')) {
      viewModel.setError("E-mail inválido para recuperação.");
      return;
    }

    await viewModel.recoverPassword(emailTyped);

    if (!context.mounted) return;

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