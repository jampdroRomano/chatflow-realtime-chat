import 'package:flutter/material.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../core/utils/app_validators.dart'; 
import '../common/app_dialog.dart';
import '../common/dialog_builder.dart';

class AuthFlowHelper {
  
  // --- LOGIN ---
  static Future<void> login(
    BuildContext context, {
    required AuthViewModel viewModel,
    required String email,
    required String password,
  }) async {
    FocusScope.of(context).unfocus(); 
    
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

    final nameError = AppValidators.validateName(name);
    final emailError = AppValidators.validateEmail(email);
    final passError = AppValidators.validatePassword(password);

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

    await viewModel.register(email, password, name);

    if (!context.mounted) return;

    if (viewModel.successMessage != null) {
      final dialogBuilder = DialogBuilder(context);

      await dialogBuilder.show(
        AppDialog(
          type: DialogType.success,
          title: "Conta Criada!",
          description: viewModel.successMessage,
          mainButtonText: "IR PARA LOGIN",
        ),
      );
      onSuccess(); 
    }
  }

  // --- RECUPERAÇÃO DE SENHA ---
  static Future<void> recoverPassword(
    BuildContext context, {
    required AuthViewModel viewModel,
  }) async {
    FocusScope.of(context).unfocus();

    final dialogBuilder = DialogBuilder(context);
    final emailTyped = await dialogBuilder.showPasswordRecoveryDialog();

    if (emailTyped == null || emailTyped.isEmpty) return;

    final emailError = AppValidators.validateEmail(emailTyped);
    if (emailError != null) {
      viewModel.setError(emailError);
      return;
    }

    await viewModel.recoverPassword(emailTyped);

    if (!context.mounted) return;

    if (viewModel.successMessage != null) {
      await dialogBuilder.show(
        AppDialog(
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
      await dialogBuilder.show(
        AppDialog(
          type: DialogType.error,
          title: "Ocorreu um erro",
          description: viewModel.errorMessage,
          mainButtonText: "TENTAR NOVAMENTE",
        ),
      );
    }
  }
}