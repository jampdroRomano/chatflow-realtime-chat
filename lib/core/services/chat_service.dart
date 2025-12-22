import 'package:firebase_database/firebase_database.dart';
import '../../data/models/message_model.dart';

class ChatService {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child(
    'messages',
  );

  Future<void> sendMessage(
    String text,
    String userId,
    String userName, {
    String? replyToMessageId,
    String? replyToSenderName,
    String? replyToText,
  }) async {
    await _messagesRef.push().set({
      'text': text,
      'senderId': userId,
      'senderName': userName,
      'timestamp': DateTime.now().toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
      'replyToText': replyToText,
    });
  }

  Stream<List<ChatMessage>> getMessagesStream() {
    return _messagesRef.orderByChild('timestamp').onValue.map((event) {
      final List<ChatMessage> messages = [];
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        data.forEach((key, value) {
          messages.add(ChatMessage.fromMap(key, value));
        });
      }
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }
}
