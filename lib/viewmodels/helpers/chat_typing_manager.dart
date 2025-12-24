import 'dart:async';
import '../../core/services/chat_service.dart'; 

class ChatTypingManager {
  final ChatService _service;
  final String currentUserId;
  final String currentUserName;
  final Function notifyCallback; 

  ChatTypingManager({
    required ChatService service,
    required this.currentUserId,
    required this.currentUserName,
    required this.notifyCallback,
  }) : _service = service;

  List<String> _usersTypingNames = [];
  StreamSubscription? _typingSubscription;
  Timer? _debounceTimer;
  bool _isTyping = false;

  void init() {
    _typingSubscription = _service.getTypingUsersStream().listen((users) {
      _usersTypingNames = users
          .where((u) => u['id'] != currentUserId)
          .map((u) => u['name'] ?? 'Alguém')
          .toList();
      notifyCallback();
    });
  }

  void dispose() {
    _typingSubscription?.cancel();
    _debounceTimer?.cancel();
    if (_isTyping) {
       _service.setTypingStatus(currentUserId, currentUserName, false);
    }
  }

  // Lógica de Debounce (Timer)
  void onTextChanged(String text) {
    if (text.isEmpty) {
      _stopTyping();
      return;
    }

    if (!_isTyping) {
      _isTyping = true;
      _service.setTypingStatus(currentUserId, currentUserName, true);
    }

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      _stopTyping();
    });
  }

  void _stopTyping() {
    _isTyping = false;
    _service.setTypingStatus(currentUserId, currentUserName, false);
    _debounceTimer?.cancel();
  }

  // Formatação de texto
  String getHeaderStatusText(int onlineCount) {
    if (_usersTypingNames.isEmpty) {
      return "$onlineCount online";
    }
    
    final names = _usersTypingNames.map((n) => _truncateName(n)).toList();
    
    if (names.length == 1) {
      return "${names.first} está a escrever...";
    } else if (names.length == 2) {
      return "${names.first} e ${names.last} estão a escrever...";
    } else {
      return "${names.first} e outros ${names.length - 1} estão a escrever...";
    }
  }

  String _truncateName(String name) {
    if (name.length > 10) return "${name.substring(0, 10)}...";
    return name;
  }
}