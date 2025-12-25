class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String? replyToMessageId;
  final String? replyToSenderName;
  final String? replyToSenderId;
  final String? replyToText;
  final bool isDeleted;
  final Map<String, String> reactions;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.replyToMessageId,
    this.replyToSenderName,
    this.replyToSenderId,
    this.replyToText,
    this.isDeleted = false,
    this.reactions = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
      'replyToSenderId': replyToSenderId,
      'replyToText': replyToText,
      'isDeleted': isDeleted,
      'reactions': reactions,
    };
  }

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> map) {
    final rawReactions = map['reactions'] as Map<dynamic, dynamic>?;
    final Map<String, String> parsedReactions = {};

    if (rawReactions != null) {
      rawReactions.forEach((key, value) {
        if (key is String && value is String) {
          parsedReactions[key] = value;
        }
      });
    }
    return ChatMessage(
      id: id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? 'Desconhecido',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      replyToMessageId: map['replyToMessageId'],
      replyToSenderName: map['replyToSenderName'],
      replyToSenderId: map['replyToSenderId'],
      replyToText: map['replyToText'],
      isDeleted: map['isDeleted'] ?? false,
      reactions: parsedReactions,
    );
  }
}
