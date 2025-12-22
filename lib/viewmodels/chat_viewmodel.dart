import 'package:flutter/foundation.dart';
import '../core/services/chat_service.dart';
import '../models/message_model.dart';

class ChatUiItem {
  final ChatMessage message;
  final bool showTail;
  final bool showDate;

  ChatUiItem({
    required this.message,
    required this.showTail,
    required this.showDate,
  });
}

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final String currentUserId;
  final String currentUserName;
  final String currentUserEmail; 

  final Set<String> _selectedMessageIds = {};
  final List<ChatMessage> _selectedMessages = []; 
  
  ChatMessage? _replyingTo;

  ChatViewModel({
    required this.currentUserId, 
    required this.currentUserName,
    required this.currentUserEmail, 
  });

  Stream<List<ChatUiItem>> get messagesUiStream {
    return _chatService.getMessagesStream().map((rawMessages) {
      final messages = rawMessages.reversed.toList();
      
      return List.generate(messages.length, (index) {
        final message = messages[index];
        
        bool showTail = true;
        if (index < messages.length - 1) {
           final olderMessage = messages[index + 1];
           if (olderMessage.senderId == message.senderId) {
             showTail = false;
           }
        }

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

        return ChatUiItem(
          message: message,
          showTail: showTail,
          showDate: showDate,
        );
      });
    });
  }

  // Getters
  bool get isSelectionMode => _selectedMessageIds.isNotEmpty;
  int get selectedCount => _selectedMessageIds.length;
  ChatMessage? get replyingTo => _replyingTo;
  List<ChatMessage> get selectedMessages => List.unmodifiable(_selectedMessages);
  int get onlineUsersCount => 12;

  bool get canReply => _selectedMessageIds.length == 1;
  bool get canDelete {
    if (_selectedMessageIds.isEmpty) return false;
    return _selectedMessages.every((msg) => msg.senderId == currentUserId);
  }

  bool isMessageSelected(String id) => _selectedMessageIds.contains(id);

  void toggleSelection(ChatMessage message) {
    if (_selectedMessageIds.contains(message.id)) {
      _selectedMessageIds.remove(message.id);
      _selectedMessages.removeWhere((m) => m.id == message.id);
    } else {
      _selectedMessageIds.add(message.id);
      _selectedMessages.add(message);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedMessageIds.clear();
    _selectedMessages.clear();
    notifyListeners();
  }

  void setReplyingTo(ChatMessage? message) {
    _replyingTo = message;
    clearSelection();
  }

  void cancelReply() {
    _replyingTo = null;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    await _chatService.sendMessage(
      text, 
      currentUserId, 
      currentUserName,
      replyToMessageId: _replyingTo?.id,
      replyToSenderName: _replyingTo?.senderName,
      replyToSenderId: _replyingTo?.senderId,
      replyToText: _replyingTo?.text
    );

    _replyingTo = null;
    notifyListeners();
  }

  Future<void> deleteSelectedMessages() async {
    if (!canDelete) return;
    for (var msg in _selectedMessages) {
      await _chatService.markMessageAsDeleted(msg.id);
    }
    clearSelection();
  }
}