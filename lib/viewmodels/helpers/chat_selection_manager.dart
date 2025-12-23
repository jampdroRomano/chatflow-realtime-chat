import '../../models/message_model.dart'; 

class ChatSelectionManager {
  final Set<String> _selectedIds = {};
  final List<ChatMessage> _selectedMessages = [];
  ChatMessage? replyingTo;

  // Getters
  bool get isSelectionMode => _selectedIds.isNotEmpty;
  int get selectedCount => _selectedIds.length;
  List<ChatMessage> get selectedMessages => List.unmodifiable(_selectedMessages);
  bool get canReply => _selectedIds.length == 1;
  
  bool canDelete(String currentUserId) {
    if (_selectedIds.isEmpty) return false;
    return _selectedMessages.every((msg) => msg.senderId == currentUserId);
  }

  bool isSelected(String id) => _selectedIds.contains(id);

  // Actions
  void toggle(ChatMessage message) {
    if (_selectedIds.contains(message.id)) {
      _selectedIds.remove(message.id);
      _selectedMessages.removeWhere((m) => m.id == message.id);
    } else {
      _selectedIds.add(message.id);
      _selectedMessages.add(message);
    }
  }

  void clear() {
    _selectedIds.clear();
    _selectedMessages.clear();
  }

  void setReply(ChatMessage? message) {
    replyingTo = message;
    clear(); 
  }

  void cancelReply() {
    replyingTo = null;
  }
}