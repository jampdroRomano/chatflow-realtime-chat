import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import '../../viewmodels/chat_viewmodel.dart';
import '../../data/models/message_model.dart';
import 'components/chat_app_bar.dart';
import 'components/message_bubble.dart';
import 'components/date_separator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    
    // Injetamos o ViewModel aqui
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(
        currentUserId: currentUser.uid,
        currentUserName: currentUser.displayName ?? currentUser.email!.split('@')[0],
      ),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
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
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser.uid;
                          
                          // Lógica da "Perninha" (Tail)
                          // Tem perninha se for o primeiro da sequencia do mesmo usuário
                          bool showTail = true;
                          if (index > 0) {
                             final prevMessage = messages[index - 1];
                             if (prevMessage.senderId == message.senderId) {
                               showTail = false;
                             }
                          }

                          // Lógica da Data (Hoje, Ontem...)
                          bool showDate = false;
                          if (index == 0) {
                            showDate = true;
                          } else {
                            final prevDate = messages[index - 1].timestamp;
                            final currDate = message.timestamp;
                            if (prevDate.day != currDate.day) showDate = true;
                          }

                          return Column(
                            children: [
                              if (showDate) DateSeparator(date: message.timestamp),
                              MessageBubble(
                                message: message,
                                isMe: isMe,
                                showTail: showTail,
                                onLongPress: () => viewModel.selectMessage(message),
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
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade100,
                    child: Row(
                      children: [
                        const Icon(Icons.reply, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Respondendo a ${viewModel.replyingTo!.senderName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(viewModel.replyingTo!.text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: viewModel.cancelReply)
                      ],
                    ),
                  ),

                // CAMPO DE INPUT
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Digite uma mensagem...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: const Color(0xFF125DFF),
                        child: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          viewModel.sendMessage(_textController.text);
                          _textController.clear();
                          // Scroll pro final
                          if (_scrollController.hasClients) {
                             _scrollController.animateTo(
                               _scrollController.position.maxScrollExtent + 60,
                               duration: const Duration(milliseconds: 300),
                               curve: Curves.easeOut,
                             );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}