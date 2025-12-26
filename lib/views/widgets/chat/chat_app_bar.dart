import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import 'online_users_sheet.dart'; 

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  // Função auxiliar para abrir a lista de membros
  void _showMembersList(BuildContext context) {
    // 1. Captura o ViewModel da tela atual ANTES de abrir o modal
    final chatVM = Provider.of<ChatViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (newContext) {
        // 2. Re-injeta o MESMO ViewModel dentro do contexto do Modal
        return ChangeNotifierProvider.value(
          value: chatVM,
          child: const OnlineUsersSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final theme = Theme.of(context);

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
      // Título Clicável
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("ChatFlow"),
            Text(
              chatVM.headerStatusText,
              style: TextStyle(
                fontSize: 12,
                color: chatVM.headerStatusText.contains("escrever")
                    ? theme.colorScheme.secondary
                    : Colors.green,
                fontWeight: chatVM.headerStatusText.contains("escrever")
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              authVM.logout();
            } else if (value == 'members') {
              _showMembersList(context);
            }
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
              value: 'members',
              child: Row(
                children: [Icon(Icons.group, color: Colors.blueGrey), SizedBox(width: 8), Text("Membros")],
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