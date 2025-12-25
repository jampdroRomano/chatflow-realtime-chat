import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/services/chat_service.dart';
import '../core/utils/chat_ui_transformer.dart';
import '../models/message_model.dart';
import 'helpers/chat_selection_manager.dart'; 
import 'helpers/chat_typing_manager.dart';    

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

    _typingManager.init();
  }

  @override
  void dispose() {
    _onlineUsersSubscription?.cancel();
    _typingManager.dispose();
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
    return _chatService.getMessagesStream().map(ChatUiTransformer.transformMessages);
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

    _selectionManager.cancelReply(); 
    notifyListeners();
  }

  Future<void> reactToMessage(ChatMessage message, String reaction) async {
    await _chatService.toggleReaction(message.id, currentUserId, reaction);
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