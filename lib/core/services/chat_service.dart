import 'package:firebase_database/firebase_database.dart';
import '../../models/message_model.dart';

class ChatService {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');


  Future<void> sendMessage(String text, String userId, String userName, {String? replyToMessageId, String? replyToSenderName, String? replyToText}) async {
    await _messagesRef.push().set({
      'text': text,
      'senderId': userId,
      'senderName': userName,
      'timestamp': DateTime.now().toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
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
}