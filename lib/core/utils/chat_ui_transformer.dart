import '../../models/message_model.dart';
import '../../viewmodels/chat_viewmodel.dart';

class ChatUiTransformer {
  static List<ChatUiItem> transformMessages(List<ChatMessage> rawMessages) {
    final messages = rawMessages.reversed.toList();
    return List.generate(messages.length, (index) {
      final message = messages[index];
      bool showTail = true;
      if (index < messages.length - 1) {
        if (messages[index + 1].senderId == message.senderId) {
          showTail = false;
        }
      }
      bool showDate = false;
      if (index == messages.length - 1) {
        showDate = true;
      } else {
        final curr = message.timestamp;
        final old = messages[index + 1].timestamp;
        if (curr.day != old.day ||
            curr.month != old.month ||
            curr.year != old.year) {
          showDate = true;
        }
      }
      return ChatUiItem(
          message: message, showTail: showTail, showDate: showDate);
    });
  }
}
