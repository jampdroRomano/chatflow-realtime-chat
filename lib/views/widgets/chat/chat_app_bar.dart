import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../../core/theme/app_theme.dart'; // <--- Import do Tema

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    if (chatVM.isSelectionMode) {
      // A AppBar vai herdar tudo (Azul/Branco) automaticamente.
      return Theme(
        data: AppTheme.selectionTheme, 
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close), 
            onPressed: () => chatVM.clearSelection(),
          ),
          title: Text("${chatVM.selectedCount}"), 
          actions: [
            if (chatVM.canReply)
              IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () {
                  if (chatVM.selectedMessages.isNotEmpty) {
                    chatVM.setReplyingTo(chatVM.selectedMessages.first);
                  }
                },
              ),
            
            if (chatVM.canDelete)
              IconButton(
                icon: const Icon(Icons.delete), 
                onPressed: () => chatVM.deleteSelectedMessages(),
              ),
          ],
        ),
      );
    }

    // MODO NORMAL (Usa o tema padrão do main.dart)
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ChatFlow"), // Estilo vem do lightTheme padrão
          Text(
            "${chatVM.onlineUsersCount} online",
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          // O ícone padrão já vem preto do tema lightTheme
          onSelected: (value) {
            if (value == 'logout') authVM.logout();
          },
          itemBuilder: (context) => [
             PopupMenuItem(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chatVM.currentUserName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text("usuario@email.com", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Divider(),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 8), Text("Sair")],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}