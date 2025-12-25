import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/chat_viewmodel.dart';

class OnlineUsersSheet extends StatelessWidget {
  const OnlineUsersSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5, 
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Indicador de "puxar"
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Título
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Membros Online",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Lista
              Expanded(
                child: Consumer<ChatViewModel>(
                  builder: (context, viewModel, child) {
                    final users = viewModel.onlineMemberNames;
                    
                    if (users.isEmpty) {
                      return const Center(child: Text("Ninguém online além de fantasmas... 👻"));
                    }

                    return ListView.separated(
                      controller: scrollController,
                      itemCount: users.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 60),
                      itemBuilder: (context, index) {
                        final name = users[index];
                        final isMe = name == viewModel.currentUserName;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isMe 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey.shade200,
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : "?",
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          title: Text(
                            isMe ? "$name (Você)" : name,
                            style: TextStyle(
                              fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}