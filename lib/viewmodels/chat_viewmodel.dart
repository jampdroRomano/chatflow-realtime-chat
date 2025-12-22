import 'package:flutter/material.dart';
import '../core/services/chat_service.dart';
import '../data/models/message_model.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final String currentUserId;
  final String currentUserName;

  // Controle de Seleção e Resposta
  ChatMessage? _selectedMessage; 
  ChatMessage? _replyingTo;    
  
  ChatMessage? get selectedMessage => _selectedMessage;
  ChatMessage? get replyingTo => _replyingTo;

  // Mock de usuários online (Backend real virá depois)
  int get onlineUsersCount => 12; 

  ChatViewModel({required this.currentUserId, required this.currentUserName});

  Stream<List<ChatMessage>> get messagesStream => _chatService.getMessagesStream();

  // Selecionar mensagem 
  void selectMessage(ChatMessage? message) {
    _selectedMessage = message;
    notifyListeners(); 
  }

  // Entrar em modo de resposta
  void setReplyingTo(ChatMessage? message) {
    _replyingTo = message;
    _selectedMessage = null; 
    notifyListeners();
  }

  // Cancelar resposta
  void cancelReply() {
    _replyingTo = null;
    notifyListeners();
  }

  // Enviar mensagem (Agora suporta resposta)
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Se estiver respondendo, anexa os dados
    await _chatService.sendMessage(
      text, 
      currentUserId, 
      currentUserName,
      replyToMessageId: _replyingTo?.id,
      replyToSenderName: _replyingTo?.senderName,
      replyToText: _replyingTo?.text
    );

    // Limpa o estado
    debugPrint("Deletar mensagem: ${_selectedMessage!.id}"); 
      
      _selectedMessage = null;
      notifyListeners();
  }

  // Excluir mensagem (Falta implementar no Service)
  Future<void> deleteSelectedMessage() async {
    if (_selectedMessage != null) {
      // await _chatService.deleteMessage(_selectedMessage!.id);
      print("Deletar mensagem: ${_selectedMessage!.id}"); // Placeholder
      _selectedMessage = null;
      notifyListeners();
    }
  }
}