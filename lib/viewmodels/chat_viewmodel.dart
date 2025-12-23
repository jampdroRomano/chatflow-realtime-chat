import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/services/chat_service.dart';
import '../models/message_model.dart';
import 'helpers/chat_selection_manager.dart'; 
import 'helpers/chat_typing_manager.dart';    

// Movi a ChatUiItem para fora ou mantenha aqui se for pequena
class ChatUiItem {
  final ChatMessage message;
  final bool showTail;
  final bool showDate;
  ChatUiItem({required this.message, required this.showTail, required this.showDate});
}

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final String currentUserId;
  final String currentUserName;
  final String currentUserEmail;

  // Composição: Instâncias dos nossos helpers
  late final ChatSelectionManager _selectionManager;
  late final ChatTypingManager _typingManager;

  int _onlineUsersCount = 1; 
  StreamSubscription<int>? _onlineUsersSubscription;

  ChatViewModel({
    required this.currentUserId, 
    required this.currentUserName,
    required this.currentUserEmail,
  }) {
    // Inicializa os helpers
    _selectionManager = ChatSelectionManager();
    _typingManager = ChatTypingManager(
      service: _chatService,
      currentUserId: currentUserId,
      currentUserName: currentUserName,
      notifyCallback: notifyListeners, 
    );

    _initPresence();
  }

  void _initPresence() {
    _chatService.connectUser(currentUserId);
    _onlineUsersSubscription = _chatService.getOnlineUsersCountStream().listen((count) {
      _onlineUsersCount = count;
      notifyListeners();
    });
    
    // Inicia o listener de typing
    _typingManager.init();
  }

  @override
  void dispose() {
    _onlineUsersSubscription?.cancel();
    _typingManager.dispose(); // O manager limpa os timers dele
    _chatService.disconnectUser(currentUserId);
    super.dispose();
  }

  // --- GETTERS (Delegando para os Managers) ---
  String get headerStatusText => _typingManager.getHeaderStatusText(_onlineUsersCount);
  
  bool get isSelectionMode => _selectionManager.isSelectionMode;
  int get selectedCount => _selectionManager.selectedCount;
  ChatMessage? get replyingTo => _selectionManager.replyingTo;
  List<ChatMessage> get selectedMessages => _selectionManager.selectedMessages;
  bool get canReply => _selectionManager.canReply;
  bool get canDelete => _selectionManager.canDelete(currentUserId);
  int get onlineUsersCount => _onlineUsersCount;

  bool isMessageSelected(String id) => _selectionManager.isSelected(id);

  // --- ACTIONS (Delegando) ---
  
  void onTextChanged(String text) => _typingManager.onTextChanged(text);

  void toggleSelection(ChatMessage message) {
    _selectionManager.toggle(message);
    notifyListeners();
  }

  void clearSelection() {
    _selectionManager.clear();
    notifyListeners();
  }

  void setReplyingTo(ChatMessage? message) {
    _selectionManager.setReply(message);
    notifyListeners();
  }

  void cancelReply() {
    _selectionManager.cancelReply();
    notifyListeners();
  }

  // --- LÓGICA DE ENVIO E FLUXO ---
  
  Stream<List<ChatUiItem>> get messagesUiStream {
    // A lógica visual de datas/balões continua aqui pois é específica da View
    return _chatService.getMessagesStream().map((rawMessages) {
      final messages = rawMessages.reversed.toList();
      return List.generate(messages.length, (index) {
        final message = messages[index];
        bool showTail = true;
        if (index < messages.length - 1) {
           if (messages[index + 1].senderId == message.senderId) showTail = false;
        }
        bool showDate = false;
        if (index == messages.length - 1) {
          showDate = true;
        } else {
          final curr = message.timestamp;
          final old = messages[index + 1].timestamp;
          if (curr.day != old.day || curr.month != old.month || curr.year != old.year) showDate = true;
        }
        return ChatUiItem(message: message, showTail: showTail, showDate: showDate);
      });
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Para de digitar ao enviar
    _typingManager.onTextChanged(""); 
    
    await _chatService.sendMessage(
      text, 
      currentUserId, 
      currentUserName,
      replyToMessageId: _selectionManager.replyingTo?.id,
      replyToSenderName: _selectionManager.replyingTo?.senderName,
      replyToSenderId: _selectionManager.replyingTo?.senderId,
      replyToText: _selectionManager.replyingTo?.text
    );

    _selectionManager.cancelReply(); // Limpa o reply após enviar
    notifyListeners();
  }

  Future<void> deleteSelectedMessages() async {
    if (!canDelete) return;
    for (var msg in _selectionManager.selectedMessages) {
      await _chatService.markMessageAsDeleted(msg.id);
    }
    _selectionManager.clear();
    notifyListeners();
  }
}