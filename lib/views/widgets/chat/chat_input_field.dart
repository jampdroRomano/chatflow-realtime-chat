import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../../core/theme/app_theme.dart'; 

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Row(
        children: [
          // CAMPO DE TEXTO
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: 6,
                  decoration: AppTheme.chatInputDecoration,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8), 

          // 2. BOTÃO DE ENVIAR
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                viewModel.sendMessage(_textController.text);
                _textController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}