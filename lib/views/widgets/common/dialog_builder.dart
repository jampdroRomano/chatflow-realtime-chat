import 'package:flutter/material.dart';
import 'app_dialog.dart';
import 'custom_dialog.dart';

class DialogBuilder {
  final BuildContext context;

  DialogBuilder(this.context);

  Future<T?> show<T>(Widget dialog) {
    return showDialog<T>(
      context: context,
      builder: (context) => CustomDialog(child: dialog),
    );
  }

  Future<String?> showPasswordRecoveryDialog() async {
    final recoveryEmailController = TextEditingController();
    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) => CustomDialog(
        child: AppDialog(
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
      ),
    );

    if (shouldSend == true) {
      return recoveryEmailController.text.trim();
    }
    return null;
  }
}
