import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../viewmodels/chat_viewmodel.dart';
import '../widgets/chat/chat_app_bar.dart';
import '../widgets/chat/message_bubble.dart';
import '../widgets/chat/date_separator.dart';
import '../widgets/chat/chat_input_field.dart';
import '../widgets/chat/reply_preview_bar.dart';

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
        currentUserEmail: currentUser.email ?? '', 
      ),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: const ChatAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<ChatUiItem>>(
                    stream: viewModel.messagesUiStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      final uiItems = snapshot.data!;
                      
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: uiItems.length,
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        itemBuilder: (context, index) {
                          final item = uiItems[index];
                          final message = item.message;
                          final isMe = message.senderId == currentUser.uid;
                          final isSelected = viewModel.isMessageSelected(message.id);

                          return Column(
                            children: [
                              if (item.showDate) 
                                DateSeparator(date: message.timestamp),
                              
                              MessageBubble(
                                message: message,
                                currentUserId: currentUser.uid,
                                isMe: isMe,
                                showTail: item.showTail,
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

                if (viewModel.replyingTo != null)
                  ReplyPreviewBar(
                    replyingTo: viewModel.replyingTo!,
                    currentUserId: currentUser.uid,
                    onCancel: viewModel.cancelReply,
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