import 'package:flutter/foundation.dart';
import '../core/services/chat_service.dart';
import '../models/message_model.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final String currentUserId;
  final String currentUserName;
  final Set<String> _selectedMessageIds = {};
  final List<ChatMessage> _selectedMessages = []; 

  ChatMessage? _replyingTo;

  ChatViewModel({required this.currentUserId, required this.currentUserName});

  Stream<List<ChatMessage>> get messagesStream => _chatService.getMessagesStream();

  // --- GETTERS (AS PORTAS DE ACESSO) ---
  bool get isSelectionMode => _selectedMessageIds.isNotEmpty;
  int get selectedCount => _selectedMessageIds.length;
  ChatMessage? get replyingTo => _replyingTo;
  
  // Expondo a lista para a AppBar usar
  List<ChatMessage> get selectedMessages => List.unmodifiable(_selectedMessages);
  
  // Expondo o contador de usuários online
  int get onlineUsersCount => 12; // Mock provisório

  // --- REGRAS DE NEGÓCIO ---
  bool get canReply => _selectedMessageIds.length == 1;
  
  bool get canDelete {
    if (_selectedMessageIds.isEmpty) return false;
    // Só pode deletar se TODAS as mensagens se forem MINHAS
    return _selectedMessages.every((msg) => msg.senderId == currentUserId);
  }

  bool isMessageSelected(String id) => _selectedMessageIds.contains(id);

  // --- AÇÕES ---
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