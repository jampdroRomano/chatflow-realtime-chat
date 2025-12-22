import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../viewmodels/chat_viewmodel.dart';
import '../../models/message_model.dart';
import '../widgets/chat/chat_app_bar.dart';
import '../widgets/chat/message_bubble.dart';
import '../widgets/chat/date_separator.dart';
import '../widgets/chat/chat_input_field.dart';

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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
                Expanded(
                  child: StreamBuilder<List<ChatMessage>>(
                    stream: viewModel.messagesStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      final messages = snapshot.data!.reversed.toList();
                      
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser.uid;
                          
                          // Lógica da Perninha (Com Chaves {})
                          bool showTail = true;
                          if (index > 0) {
                             final newerMessage = messages[index - 1];
                             if (newerMessage.senderId == message.senderId) {
                               showTail = false;
                             }
                          }

                          // Lógica da Data (Com Chaves {})
                          bool showDate = false;
                          if (index == messages.length - 1) {
                            showDate = true;
                          } else {
                            final currDate = message.timestamp;
                            final olderDate = messages[index + 1].timestamp;
                            
                            if (currDate.day != olderDate.day || 
                                currDate.month != olderDate.month || 
                                currDate.year != olderDate.year) {
                              showDate = true;
                            }
                          }

                          final isSelected = viewModel.isMessageSelected(message.id);

                          return Column(
                            children: [
                              if (showDate) DateSeparator(date: message.timestamp),
                              
                              MessageBubble(
                                message: message,
                                currentUserId: currentUser.uid, // <--- Passando o ID aqui
                                isMe: isMe,
                                showTail: showTail,
                                isSelected: isSelected,
                                onLongPress: () => viewModel.toggleSelection(message),
                                onTap: () {
                                  if (viewModel.isSelectionMode) {
                                    viewModel.toggleSelection(message);
                                  }
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

                // Preview de Resposta
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
                        Container(
                          width: 4,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.replyingTo!.senderId == currentUser.uid 
                                    ? "Você" 
                                    : viewModel.replyingTo!.senderName, 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 14,
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

                ChatInput(
                  onSendMessageSuccess: _scrollToBottom,
                ),
                
                SizedBox(height: MediaQuery.of(context).padding.bottom > 0 ? 10 : 0),
              ],
            ),
          );
        },
      ),
    );
  }
}