import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../../models/message_model.dart';
import '../../widgets/chat/chat_app_bar.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/date_separator.dart';
import '../../widgets/chat/chat_input_field.dart'; 

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    
    // Cor de fundo levemente cinza/bege para destacar o input branco
    final backgroundColor = const Color(0xFFE5E5E5); 

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(
        currentUserId: currentUser.uid,
        currentUserName: currentUser.displayName ?? currentUser.email!.split('@')[0],
      ),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: backgroundColor, 
            appBar: const ChatAppBar(),
            body: Column(
              children: [
                // LISTA DE MENSAGENS
                Expanded(
                  child: StreamBuilder<List<ChatMessage>>(
                    stream: viewModel.messagesStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      final messages = snapshot.data!;
                      
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        padding: const EdgeInsets.only(bottom: 10), // Espaço pro input não cobrir
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser.uid;
                          
                          // Lógica da Perninha
                          bool showTail = true;
                          if (index > 0) {
                             final prevMessage = messages[index - 1];
                             if (prevMessage.senderId == message.senderId) showTail = false;
                          }

                          // Lógica da Data
                          bool showDate = false;
                          if (index == 0) {
                            showDate = true;
                          } else {
                            final prevDate = messages[index - 1].timestamp;
                            final currDate = message.timestamp;
                            if (prevDate.day != currDate.day) showDate = true;
                          }

                          final isSelected = viewModel.isMessageSelected(message.id);

                          return Column(
                            children: [
                              if (showDate) DateSeparator(date: message.timestamp),
                              MessageBubble(
                                message: message,
                                isMe: isMe,
                                showTail: showTail,
                                isSelected: isSelected,
                                onLongPress: () => viewModel.toggleSelection(message),
                                onTap: () {
                                  if (viewModel.isSelectionMode) viewModel.toggleSelection(message);
                                },
                                onSwipeReply: () => viewModel.setReplyingTo(message),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                // ÁREA DE RESPOSTA (PREVIEW)
                if (viewModel.replyingTo != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.reply, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Respondendo a ${viewModel.replyingTo!.senderName}", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 12, 
                                  color: Theme.of(context).colorScheme.primary
                                )
                              ),
                              Text(
                                viewModel.replyingTo!.text, 
                                maxLines: 1, 
                                overflow: TextOverflow.ellipsis, 
                                style: const TextStyle(color: Colors.grey)
                              ),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: viewModel.cancelReply)
                      ],
                    ),
                  ),

                // NOVO INPUT FLUTUANTE
                const ChatInput(), // <--- Olha como ficou limpo!
                
                // Espaço extra se for iOS (SafeArea)
                SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 20 : 0),
              ],
            ),
          );
        },
      ),
    );
  }
}