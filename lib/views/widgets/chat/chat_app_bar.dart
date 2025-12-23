import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../../core/theme/app_theme.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    if (chatVM.isSelectionMode) {
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

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ChatFlow"),
          // MUDANÇA AQUI: Usa o texto dinâmico do ViewModel
          Text(
            chatVM.headerStatusText, 
            style: TextStyle(
              fontSize: 12, 
              color: chatVM.headerStatusText.contains("a escrever") 
                  ? AppTheme.successColor 
                  : AppTheme.successColor,
              fontWeight: chatVM.headerStatusText.contains("escrever")
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
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
                  Text(chatVM.currentUserEmail, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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