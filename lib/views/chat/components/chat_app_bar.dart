import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/chat_viewmodel.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final isSelectionMode = chatVM.selectedMessage != null;

    return AppBar(
      backgroundColor: isSelectionMode ? Colors.blue.shade900 : Colors.white,
      foregroundColor: isSelectionMode ? Colors.white : Colors.black,
      elevation: 1,
      leading: isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => chatVM.selectMessage(null),
            )
          : null, // Default back button
      title: isSelectionMode
          ? const Text("1 selecionado")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("ChatFlow", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "${chatVM.onlineUsersCount} online",
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
      actions: isSelectionMode
          ? [
              IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () => chatVM.setReplyingTo(chatVM.selectedMessage),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => chatVM.deleteSelectedMessage(),
              ),
            ]
          : [
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
                        Text("usuario@email.com", style: TextStyle(fontSize: 12, color: Colors.grey)),
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