import 'package:flutter/material.dart';
import '../core/services/chat_service.dart';
import '../data/models/message_model.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final String currentUserId;
  final String currentUserName;

  ChatViewModel({required this.currentUserId, required this.currentUserName});

  Stream<List<ChatMessage>> get messagesStream => _chatService.getMessagesStream();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    await _chatService.sendMessage(text, currentUserId, currentUserName);
  }
}