import 'package:firebase_database/firebase_database.dart';
import '../../models/message_model.dart';

class ChatService {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');
  final DatabaseReference _presenceRef = FirebaseDatabase.instance.ref().child('presence'); 

  Future<void> sendMessage(
    String text, 
    String userId, 
    String userName, 
    {
      String? replyToMessageId, 
      String? replyToSenderName, 
      String? replyToSenderId,
      String? replyToText
    }
  ) async {
    await _messagesRef.push().set({
      'text': text,
      'senderId': userId,
      'senderName': userName,
      'timestamp': DateTime.now().toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
      'replyToSenderId': replyToSenderId,
      'replyToText': replyToText,
      'isDeleted': false,
    });
  }

  Stream<List<ChatMessage>> getMessagesStream() {
    return _messagesRef.onValue.map((event) {
      final List<ChatMessage> messages = [];
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> map = event.snapshot.value as Map<dynamic, dynamic>;
        map.forEach((key, value) {
          messages.add(ChatMessage.fromMap(key, value));
        });
      }
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  Future<void> markMessageAsDeleted(String messageId) async {
    await _messagesRef.child(messageId).update({
      'isDeleted': true,
      'text': '', 
    });
  }

  // --- PRESENÇA (ONLINE) ---
  Future<void> connectUser(String userId) async {
    final userStatusRef = _presenceRef.child(userId);

    FirebaseDatabase.instance.ref(".info/connected").onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      
      if (connected) {
        userStatusRef.onDisconnect().remove();
        userStatusRef.set(true);
      }
    });
  }

  Future<void> disconnectUser(String userId) async {
    await _presenceRef.child(userId).remove();
  }

  // Conta quantos filhos existem no nó 'presence' em tempo real
  Stream<int> getOnlineUsersCountStream() {
    return _presenceRef.onValue.map((event) {
      if (event.snapshot.value == null) return 0;
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.length;
    });
  }
}